//
//  BeaconRegionViewController.m
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "BeaconRegionViewController.h"
#import "BeaconRegionCell.h"
#import "MonitoringBeaconRegion.h"
#import "AdvertisingBeaconRegion.h"
#import "RangingBeaconRegion.h"

@interface BeaconRegionViewController ()<RangingBeaconRegionDelegate, AdvertisingBeaconRegionDelegate, MonitoringBeaconRegionDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *beaconTableView;

@property (strong, nonatomic) MonitoringBeaconRegion *monitoringOperation;
@property (strong, nonatomic) AdvertisingBeaconRegion *advertisingOperation;
@property (strong, nonatomic) RangingBeaconRegion *rangingOperation;

@property (strong, nonatomic) NSArray *detectedBeacons;

@property (weak, nonatomic) UISwitch *monitoringSwitch;
@property (weak, nonatomic) UISwitch *advertisingSwitch;
@property (weak, nonatomic) UISwitch *rangingSwitch;

@property (weak, nonatomic) UIActivityIndicatorView *monitoringActivityIndicator;
@property (weak, nonatomic) UIActivityIndicatorView *advertisingActivityIndicator;

@end

@implementation BeaconRegionViewController
{

    NSInteger kMaxNumberOfSections;
    NSInteger kNumberOfAvailableOperations;
    CGPoint kActivityIndicatorPosition;
    NSString *kBeaconSectionTitle;
    NSString *kBeaconsHeaderViewIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicConfiguration];
}

- (void)basicConfiguration {
    
    // init Beacon
    {
        self.monitoringOperation = [[MonitoringBeaconRegion alloc] init];
        self.monitoringOperation.delegate = self;

        self.advertisingOperation = [[AdvertisingBeaconRegion alloc] init];
        self.advertisingOperation.delegate = self;
        
        self.rangingOperation = [[RangingBeaconRegion alloc] init];
        self.rangingOperation.delegate = self;
    }
    
    kMaxNumberOfSections = 2;
    kNumberOfAvailableOperations = 3;
    kBeaconSectionTitle = @"Ranging for beacons...";
    kActivityIndicatorPosition = CGPointMake(205, 12);
    kBeaconsHeaderViewIdentifier = @"BeaconsHeader";
}

- (NSArray *)indexPathsOfRemovedBeacons:(NSArray *)beacons {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = 0;
    
    for (CLBeacon *existingBeacon in self.detectedBeacons) {
        BOOL stillExists = NO;
        for (CLBeacon *beacon in beacons) {
            if (existingBeacon.major.integerValue == beacon.major.integerValue) {
                stillExists = true;
                break;
            }
        }
        
        if (stillExists == NO) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:1]];
        }
        row ++;
    }
    
    return indexPaths;
}

- (NSArray *)indexPathsOfInsertedBeacons:(NSArray *)beacons {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = 0;
    
    for (CLBeacon *beacon in beacons) {
        BOOL isNewBeacon = YES;
        for (CLBeacon *existingBeacon in self.detectedBeacons) {
            if ((existingBeacon.major.integerValue == beacon.major.integerValue) && existingBeacon.minor.integerValue == beacon.minor.integerValue) {
                isNewBeacon = NO;
                break;
            }
        }
        
        if (isNewBeacon == YES) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:1]];
        }
        row ++;
    }
    
    return indexPaths;
}

- (NSArray *)indexPathsForBeacons:(NSArray *)beacons {

    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int row = 0; row < beacons.count; row++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:1]];
    }
    return indexPaths;
}

- (NSIndexSet *)insertedSections {

    if ((self.rangingSwitch.on = YES) &&
        (self.beaconTableView.numberOfSections == kMaxNumberOfSections -1)) {
        return [NSIndexSet indexSetWithIndex:1];
    } else {
        return nil;
    }
}

- (NSIndexSet *)deletedSections {
    
    if ((self.rangingSwitch.on = NO) &&
        (self.beaconTableView.numberOfSections == kMaxNumberOfSections)) {
        return [NSIndexSet indexSetWithIndex:1];
    } else {
        return nil;
    }
}

- (NSArray *)filteredBeacons:(NSArray *)beacons {
    
    NSMutableArray *filteredBeacons = [NSMutableArray arrayWithArray:beacons];
    NSMutableSet *lookup = [NSMutableSet set];

    for (int index = 0; index < beacons.count; index ++) {
        CLBeacon *currentBeacon = beacons[index];
        NSString *identifier = [NSString stringWithFormat:@"%@%@",currentBeacon.major,currentBeacon.minor];
        
        if ([lookup containsObject:identifier]) {
            [filteredBeacons removeObjectAtIndex:index];
        } else {
            [filteredBeacons indexOfObject:identifier];
        }
    }
    return filteredBeacons;
}


- (NSString *)getTableViewCellTitle:(NSInteger)row {

    NSString *title = @"";
    switch (row) {
        case 0:
            title = @"Monitoring";
            break;
        case 1:
            title = @"Advertising";
            break;
        case 2:
            title = @"Ranging";
            break;
        default:
            break;
    }
    return title;
}

- (void)changeMonitoringState:(UISwitch *)monitoringSwitch {
    
    if (monitoringSwitch.on) {
        [self.monitoringOperation startMonitoringForBeacons];
    } else {
        [self.monitoringOperation stopMonitoringForBeacons];
    }
}

- (void)changeAdvertisingState:(UISwitch *)advertisingSwitch {

    if (advertisingSwitch.on) {
        [self.advertisingOperation startAdvertisingForBeacons];
    } else {
        [self.advertisingOperation stopAdvertisingForBeacons];
    }
}

- (void)changeRangingState:(UISwitch *)rangingSwitch {

    if (rangingSwitch.on) {
        [self.rangingOperation startRangingForBeacons];
    } else {
        [self.rangingOperation stopRangingForBeacons];
    }
}

- (NSString *)getBeaconFullDetails:(CLBeacon *)beacon {
    
    NSString *proximityText = nil;
    switch (beacon.proximity) {
        case CLProximityNear:
            proximityText = @"Near";
            break;
        case CLProximityImmediate:
            proximityText = @"Immediate";
            break;
        case CLProximityFar:
            proximityText = @"Far";
            break;
        case CLProximityUnknown:
            proximityText = @"Unknown";
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@,%@ • %@ • %f • %ld",beacon.major, beacon.minor, proximityText, beacon.accuracy, beacon.rssi];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"";
    if (indexPath.section == 0) {
        cellIdentifier = @"OperationCell";
    } else if (indexPath.section == 1) {
        cellIdentifier = @"BeaconCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    BeaconRegionCell *beaconCell = nil;
    CLBeacon *beacon = nil;
    
    switch (indexPath.section) {
        case 0:
            beaconCell = (BeaconRegionCell *)cell;
            beaconCell.textLabel.text = [self getTableViewCellTitle:indexPath.row];
            
            switch (indexPath.row) {
                case 0:
                    self.monitoringSwitch = (UISwitch *)beaconCell.accessoryView;
                    self.monitoringActivityIndicator = beaconCell.activityIndicator;
                    [self.monitoringSwitch addTarget:self action:@selector(changeMonitoringState:) forControlEvents:UIControlEventValueChanged];
                    if (self.monitoringSwitch.on) {
                        [self.monitoringActivityIndicator startAnimating];
                    } else {
                        [self.monitoringActivityIndicator stopAnimating];
                    }
                    break;
                case 1:
                    self.advertisingSwitch = (UISwitch *)beaconCell.accessoryView;
                    self.advertisingActivityIndicator = beaconCell.activityIndicator;
                    [self.advertisingSwitch addTarget:self action:@selector(changeAdvertisingState:) forControlEvents:UIControlEventValueChanged];
                    if (self.advertisingSwitch.on) {
                        [self.advertisingActivityIndicator startAnimating];
                    } else {
                        [self.advertisingActivityIndicator stopAnimating];
                    }
                    break;
                case 2:
                    self.rangingSwitch = (UISwitch *)beaconCell.accessoryView;
                    [self.rangingSwitch addTarget:self action:@selector(changeRangingState:) forControlEvents:UIControlEventValueChanged];
                default:
                    break;
            }
            break;
            
        case 1:
            beacon = self.detectedBeacons[indexPath.row];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = [beacon.proximityUUID UUIDString];
            cell.detailTextLabel.text = [self getBeaconFullDetails:beacon];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        default:
            break;
    }
    
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.rangingSwitch.on) {
        return kMaxNumberOfSections;
    } else {
        return kMaxNumberOfSections -1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return kNumberOfAvailableOperations;
        case 1:
            return self.detectedBeacons.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return nil;
        case 1:
            return kBeaconSectionTitle;
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            return 44;
        case 1:
            return 52;
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kBeaconsHeaderViewIdentifier];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [headerView addSubview:indicatorView];
    indicatorView.frame = CGRectMake(205, 12, indicatorView.frame.size.width, indicatorView.frame.size.height);
    [indicatorView stopAnimating];
    return headerView;
}

#pragma mark - MonitoringBeaconRegionDelegate
- (void)monitoringOperationDidStartSuccessfully {
    self.monitoringSwitch.on = YES;
    [self.monitoringActivityIndicator startAnimating];
}

- (void)monitoringOperationDidStopSuccessfully {
    [self.monitoringActivityIndicator stopAnimating];
}

- (void)monitoringOperationDidFailToStart {
    self.monitoringSwitch.on = NO;
}

- (void)monitoringOperationDidFailToStartDueToAuthorization {

    NSString *title = @"Missing Location Access";
    NSString *message = @"Location Access (Always) is required. Click Settings to update the location access settings.";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *settingsButtonTitle = @"Settings";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:settingsButtonTitle, nil];
    [alert show];
    
    self.monitoringSwitch.on = NO;
}

- (void)monitoringOperationDidDetectEnteringRegion:(CLBeaconRegion *)region {
 
    // 发送通知
}

#pragma mark - AdvertisingBeaconRegionDelegate
- (void)advertisingOperationDidStartSuccessfully {
    self.advertisingSwitch.on = YES;
    [self.advertisingActivityIndicator startAnimating];
}

- (void)advertisingOperationDidStopSuccessfully {
    [self.advertisingActivityIndicator stopAnimating];
}

- (void)advertisingOperationDidFailToStart {
    
    NSString *title = @"Bluetooth is off";
    NSString *message = @"It seems that Bluetooth is off. For advertising to work, please turn Bluetooth on.";
    NSString *cancelButtonTitle = @"OK";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
    
    self.advertisingSwitch.on = NO;
}

#pragma mark - RangingBeaconRegionDelegate
- (void)rangingOperationDidStartSuccessfully {

    self.detectedBeacons = [NSArray array];
    self.rangingSwitch.on = YES;
}

- (void)rangingOperationDidStopSuccessfully {
    
    self.detectedBeacons = [NSArray array];
    [self.beaconTableView beginUpdates];
    if ([self deletedSections] ) {
        [self.beaconTableView deleteSections:[self deletedSections] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.beaconTableView endUpdates];
}

- (void)rangingOperationDidFailToStart {
    self.rangingSwitch.on = NO;
}

- (void)rangingOperationDidFailToStartDueToAuthorization {

    NSString *title = @"Missing Location Access";
    NSString *message = @"Location Access (When In Use) is required. Click Settings to update the location access settings.";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *settingsButtonTitle = @"Settings";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:settingsButtonTitle, nil];
    [alert show];
    
    self.rangingSwitch.on = NO;
}

- (void)rangingOperationDidRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    NSArray *filteredBeacons = [self filteredBeacons:beacons];

    if (!filteredBeacons) {
        NSLog(@"No beacons found nearby.");
    } else {
        
        NSString *beaconsString;
        if (filteredBeacons.count > 1) {
            beaconsString = @"beacons";
        } else {
            beaconsString = @"beacon";
        }
        NSLog(@"Found %ld %@",filteredBeacons.count, beaconsString);
    }

    NSArray *insertedRows = [self indexPathsOfInsertedBeacons:filteredBeacons];
    NSArray *deletedRows = [self indexPathsOfRemovedBeacons:filteredBeacons];
    NSArray *reloadedRows;
    
    if ((deletedRows == nil) && (insertedRows == nil)) {
        reloadedRows = [self indexPathsForBeacons:filteredBeacons];
    }
    
    self.detectedBeacons = filteredBeacons;
    [self.beaconTableView beginUpdates];
    
    if ([self insertedSections]) {
        [self.beaconTableView insertSections:[self insertedSections] withRowAnimation:UITableViewRowAnimationFade];
    }
    if ([self deletedSections]) {
        [self.beaconTableView insertSections:[self deletedSections] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (insertedRows) {
        [self.beaconTableView insertRowsAtIndexPaths:insertedRows withRowAnimation:UITableViewRowAnimationFade];
    }
    if (deletedRows) {
        [self.beaconTableView insertRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationFade];
    }
    if (reloadedRows) {
        [self.beaconTableView insertRowsAtIndexPaths:reloadedRows withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.beaconTableView endUpdates];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }
}

@end
