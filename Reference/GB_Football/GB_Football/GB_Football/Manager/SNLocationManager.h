//
//  SNLocationManager.h
//  wrongTopic
//
//  Created by wangsen on 16/1/16.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// #warning plist文件中添加
/*
 * NSLocationAlwaysUsageDescription String 应用程序始终使用定位服务
 * NSLocationWhenInUseUsageDescription String 使用应用程序期间，可以使用定位服务
 */

typedef void(^UpdateLocationSuccessBlock) (CLLocation * location, CLPlacemark * placemark);
typedef void(^UpdateLocationErrorBlock) (CLRegion * region, NSError * error);
typedef void(^UpdateLocationCompleteBlock) (CLLocation * location, CLPlacemark * placemark,NSError * error);

@interface SNLocationManager : NSObject

+ (instancetype)shareLocationManager;

/*
 * isAlwaysUse  是否后台定位 持续定位（NSLocationAlwaysUsageDescription）
 */
@property (nonatomic, assign) BOOL isAlwaysUse;
/*
 * 精度 默认 kCLLocationAccuracyKilometer
 */
@property (nonatomic, assign) CGFloat desiredAccuracy;
/*
 * 更新距离 默认10米
 */
@property (nonatomic, assign) CGFloat distanceFilter;

/**
 是否带有逆地理信息(获取逆地理信息需要联网)
 */
@property (nonatomic, assign) BOOL isReGeocode;

//开始定位
- (void)startUpdatingLocationWithComplete:(UpdateLocationCompleteBlock)complete;

@end
