//
//  BeaconRegion.h
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconRegion : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

- (void)activateLocationManagerNotifications;

@end
