//
//  GBFourPreViewViewController.h
//  GB_Football
//
//  Created by Pizza on 2016/11/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

@interface GBFourPreViewViewController : GBBaseViewController

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, strong) NSArray<NSValue*>* fourPoints;
@property (nonatomic, strong) NSArray<NSValue*>* closePoints;  //最小外切矩形四点

@property (nonatomic, strong) NSArray<NSValue*>* orignalPoints;

@end
