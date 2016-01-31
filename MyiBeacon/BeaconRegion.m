//
//  BeaconRegion.m
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "BeaconRegion.h"

@implementation BeaconRegion

- (CLBeaconRegion *)getBeaconRegion {

    NSString *uuidString = @"416C0120-5960-4280-A67C-A2A9BB166D0F";
    NSString *identifier = @"Identifier";

    if (!self.beaconRegion) {
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuidString] identifier:identifier];
        self.beaconRegion.notifyEntryStateOnDisplay = true;
    }

    return self.beaconRegion;
}
- (CLLocationManager *)getLocationManager {

    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self.locationManager;
}

- (void)activateLocationManagerNotifications {
    self.locationManager.delegate = self;
}

@end
