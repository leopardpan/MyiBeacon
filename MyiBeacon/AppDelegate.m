//
//  AppDelegate.m
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/29.
//  Copyright (c) 2016年 TendCloud. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (readonly, nonatomic, assign) CLProximity *lastProximity;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupLocation];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)setupLocation {

    NSLog(@"setupLocation");
    
    NSString *uuidStr = @"416C0120-5960-4280-A67C-A2A9BB166D0F";
    NSString *identifier = @"Identifier";
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"didRangeBeacons");
    
    ViewController *vc = (ViewController *)self.window.rootViewController;
    vc.beacons = beacons;
    [vc.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"You entered the region");

    [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    [manager startUpdatingLocation];
    [self sendLocalNotificationWithMessage:@"You entered the region" playSound:YES];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"You exited the region");
    
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    [manager stopUpdatingLocation];

    [self sendLocalNotificationWithMessage:@"You exited the region" playSound:NO];
}

- (void)sendLocalNotificationWithMessage:(NSString *)message playSound:(BOOL)playSound {

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    if (playSound) {
        notification.soundName = @"2.wav";
    } else {
        notification.soundName = @"1.wav";
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
