//
//  AdvertisingBeaconRegion.h
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "BeaconRegion.h"
#import <CoreLocation/CoreLocation.h>

@protocol AdvertisingBeaconRegionDelegate <NSObject>

- (void)advertisingOperationDidStartSuccessfully;
- (void)advertisingOperationDidFailToStart;
- (void)advertisingOperationDidFailToStartDueToAuthorization;
- (void)advertisingOperationDidStopSuccessfully;
- (void)advertisingOperationDidRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;


@end

@interface AdvertisingBeaconRegion : BeaconRegion

@property (weak, nonatomic) id <AdvertisingBeaconRegionDelegate> delegate;

- (void)startAdvertisingForBeacons;
- (void)turnOnAdvertising;
- (void)stopAdvertisingForBeacons;

@end
