//
//  MonitoringBeaconRegion.m
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/31.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "MonitoringBeaconRegion.h"

@implementation MonitoringBeaconRegion

- (void)startMonitoringForBeacons {

    [self activateLocationManagerNotifications];
    
    if (![CLLocationManager locationServicesEnabled]) {
        [self.delegate monitoringOperationDidFailToStart];
        return;
    }
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        [self.delegate monitoringOperationDidFailToStart];
        return;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            [self turnOnMonitoring];
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.delegate monitoringOperationDidFailToStartDueToAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
            [self.delegate monitoringOperationDidFailToStartDueToAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            [self.delegate monitoringOperationDidFailToStartDueToAuthorization];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestAlwaysAuthorization];
            break;
        default:
            break;
    }
}

- (void)turnOnMonitoring {

    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.delegate monitoringOperationDidStartSuccessfully];
}

- (void)stopMonitoringForBeacons {
    
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.delegate monitoringOperationDidStopSuccessfully];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.delegate monitoringOperationDidStartSuccessfully];
        [self turnOnMonitoring];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.delegate monitoringOperationDidFailToStart];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self.delegate monitoringOperationDidFailToStart];
    } else if (status == kCLAuthorizationStatusRestricted) {
        [self.delegate monitoringOperationDidFailToStart];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.delegate monitoringOperationDidDetectEnteringRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

}


@end
