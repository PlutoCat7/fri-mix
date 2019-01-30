//
//  SNLocationManager.m
//  wrongTopic
//
//  Created by wangsen on 16/1/16.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "SNLocationManager.h"

static SNLocationManager * _manager = nil;

@interface SNLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray<UpdateLocationCompleteBlock> *completeList;
@property (nonatomic, strong) CLLocationManager * locationManager;//定位管理器

@property (nonatomic, assign) BOOL checkAuthorization;
@property (nonatomic, assign) BOOL startLocating;

@end
@implementation SNLocationManager

+ (instancetype)shareLocationManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _isAlwaysUse = NO;
        _distanceFilter = 10.f;
        _desiredAccuracy = kCLLocationAccuracyBest;
        _completeList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)startUpdatingLocationWithComplete:(UpdateLocationCompleteBlock)complete {
    
    [self.completeList addObject:complete];
    if (self.startLocating) {
        return;
    }
    
    //定位服务是否可用
    BOOL isLocationEnabled = [CLLocationManager locationServicesEnabled];
    if (!isLocationEnabled) {
        GBLog(@"请打开定位服务");
        for (UpdateLocationCompleteBlock block in self.completeList) {
            BLOCK_EXEC(block, nil, nil, [NSError errorWithDomain:@"定位服务未打开" code:0 userInfo:nil]);
        }
        [self.completeList removeAllObjects];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请打开定位服务，才能使用定位功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    self.startLocating = YES;
    self.locationManager.delegate = self;
    if (self.checkAuthorization) {
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - 状态改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    self.checkAuthorization = YES;
    //是否具有定位权限
    if (status == kCLAuthorizationStatusNotDetermined ||
        status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusDenied ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if (!_isAlwaysUse) {
                [manager requestWhenInUseAuthorization];
            } else {
                [manager requestAlwaysAuthorization];
            }
        }
        if (_isAlwaysUse) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                manager.allowsBackgroundLocationUpdates = YES;
            }
        }
    } else {
        //精度
        manager.desiredAccuracy = _desiredAccuracy;
        //更新距离
        manager.distanceFilter = _distanceFilter;
        //定位开始
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.startLocating = NO;
    
    CLLocation *location = locations.firstObject;
    if (self.isReGeocode) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark * placemark = placemarks.firstObject;
            
            for (UpdateLocationCompleteBlock block in self.completeList) {
                BLOCK_EXEC(block, location, placemark, nil);
            }
            [self.completeList removeAllObjects];
        }];
    }else {
        for (UpdateLocationCompleteBlock block in self.completeList) {
            BLOCK_EXEC(block, location, nil, nil);
        }
        [self.completeList removeAllObjects];
    }
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    self.startLocating = YES;
    
    for (UpdateLocationCompleteBlock block in self.completeList) {
        BLOCK_EXEC(block, nil, nil, error);
    }
    [self.completeList removeAllObjects];
}

@end
