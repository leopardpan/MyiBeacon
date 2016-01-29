//
//  ViewController.h
//  MyiBeacon
//
//  Created by 潘柏信 on 16/1/29.
//  Copyright (c) 2016年 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *beacons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

