//
//  RangingBeaconRegion.h
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "BeaconRegion.h"
#import <CoreLocation/CoreLocation.h>

@protocol RangingBeaconRegionDelegate <NSObject>

- (void)rangingOperationDidStartSuccessfully;
- (void)rangingOperationDidFailToStart;
- (void)rangingOperationDidFailToStartDueToAuthorization;
- (void)rangingOperationDidStopSuccessfully;
- (void)rangingOperationDidRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end

@interface RangingBeaconRegion : BeaconRegion

@property (weak, nonatomic) id <RangingBeaconRegionDelegate> delegate;

- (void)startRangingForBeacons;
- (void)turnOnRanging;
- (void)stopRangingForBeacons;

@end
