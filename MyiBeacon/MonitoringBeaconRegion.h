//
//  MonitoringBeaconRegion.h
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "BeaconRegion.h"
#import <CoreLocation/CoreLocation.h>

@protocol MonitoringBeaconRegionDelegate <NSObject>

- (void)monitoringOperationDidStartSuccessfully;
- (void)monitoringOperationDidFailToStart;
- (void)monitoringOperationDidFailToStartDueToAuthorization;
- (void)monitoringOperationDidStopSuccessfully;
- (void)monitoringOperationDidDetectEnteringRegion:(CLBeaconRegion *)region;

@end

@interface MonitoringBeaconRegion : BeaconRegion

@property (weak, nonatomic) id<MonitoringBeaconRegionDelegate> delegate;

- (void)startMonitoringForBeacons;
- (void)turnOnMonitoring;
- (void)stopMonitoringForBeacons;

@end
