//
//  GBFourPreViewController.h
//  GB_Team
//
//  Created by gxd on 16/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

@interface GBFourPreViewController : GBBaseViewController

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, assign) CLLocationCoordinate2D onceLocation;
// 原始四点绘制
@property (nonatomic, assign) CLLocationCoordinate2D oneLocation;
@property (nonatomic, assign) CLLocationCoordinate2D twoLocation;
@property (nonatomic, assign) CLLocationCoordinate2D threeLocation;
@property (nonatomic, assign) CLLocationCoordinate2D fourLocation;
// 最小外界矩形算出的位置坐标
@property (nonatomic, assign) CLLocationCoordinate2D calOneLocation;
@property (nonatomic, assign) CLLocationCoordinate2D calTwoLocation;
@property (nonatomic, assign) CLLocationCoordinate2D calThreeLocation;
@property (nonatomic, assign) CLLocationCoordinate2D calFourLocation;

@property (nonatomic, strong) NSArray<NSValue*>* calculatePoints;
@property (nonatomic, strong) NSArray<NSValue*>* orignalPoints;

@end
