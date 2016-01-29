//
//  ViewController.m
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/29.
//  Copyright (c) 2016年 TendCloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.beacons != nil) {
        return self.beacons.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CLBeacon *beacon = self.beacons[indexPath.row];
    NSString *proximityLabel = @"";
    switch (beacon.proximity) {
        case CLProximityFar:
            proximityLabel = @"Far";
            break;
        case CLProximityNear:
            proximityLabel = @"Near";
            break;
        case CLProximityImmediate:
            proximityLabel = @"Immediate";
            break;
        case CLProximityUnknown:
            proximityLabel = @"Unknown";
            break;
        default:
            break;
    }
    cell.textLabel.text = proximityLabel;
    
    NSString *detailLabel = [NSString stringWithFormat:@"Major: %@, Minor: %@, RSSI: %ld, UUID: %@",beacon.major,beacon.minor,(long)beacon.rssi,beacon.proximityUUID.UUIDString];
    cell.detailTextLabel.text = detailLabel;
    return cell;
}
@end
