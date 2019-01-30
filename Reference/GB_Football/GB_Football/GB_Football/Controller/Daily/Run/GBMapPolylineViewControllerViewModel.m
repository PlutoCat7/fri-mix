//
//  GBMapPolylineViewControllerViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMapPolylineViewControllerViewModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

#define kMaxSpeed 10   //最高速度
#define KMaxDistance 100   //两点的最大距离， 用于飘星后续点的处理
#define KMinDistance 0   //两点的最小距离， 用于飘星后续点的处理

@implementation GBMapPolylineViewControllerViewModel

- (instancetype)initWithDictData:(NSDictionary *)dictData exceptionBlock:(void(^)())exceptionBlock  {
    
    self = [super init];
    if (self) {
        _exceptionBlock = exceptionBlock;
        [self parseRunInfo:dictData];
    }
    return self;
}

- (UIImage *)imageWithOriginImage:(UIImage *)originImage addView:(UIView *)addView {
    
    UIGraphicsBeginImageContextWithOptions(addView.size, NO, 0);
    [addView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *addImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    [originImage drawAtPoint:CGPointMake(0, 0)];
    [addImage drawAtPoint:CGPointMake(0, originImage.size.height-addImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Private

- (void)parseRunInfo:(NSDictionary *)dictData {
    
    @try {
        CGFloat accuracy = 100000.0f;
        CLLocationDegrees startLon = [[dictData objectForKey:@"start_longitude"] integerValue]/accuracy;
        CLLocationDegrees startLat = [[dictData objectForKey:@"start_latitude"] integerValue]/accuracy;
        CLLocationCoordinate2D location = AMapLocationCoordinateConvert(CLLocationCoordinate2DMake(startLat, startLon), AMapLocationCoordinateTypeGPS);
        startLat = location.latitude;
        startLon = location.longitude;
        NSArray<NSDictionary *> *locationList = [dictData objectForKey:@"items"];
        
        NSInteger errorPointCount = 0;
        NSMutableArray<RunInfo *> *tmpList = [NSMutableArray arrayWithCapacity:1];
        for(NSDictionary *dict in locationList) {
            
            RunInfo *runInfo = [[RunInfo alloc] init];
            runInfo.time = [[dict objectForKey:@"interval_time"] integerValue];
            runInfo.lat = startLat + ([[dict objectForKey:@"interval_latitude"] integerValue]/accuracy);
            runInfo.lon = startLon + ([[dict objectForKey:@"interval_longitude"] integerValue]/accuracy);
            runInfo.speed = [[dict objectForKey:@"speed"] floatValue]*0.2/3.6;
            
            RunInfo *lastRunInfo = [tmpList lastObject];
            if (lastRunInfo) {
                CLLocation *orig = [[CLLocation alloc] initWithLatitude:runInfo.lat  longitude:runInfo.lon];
                CLLocation* dist = [[CLLocation alloc] initWithLatitude:lastRunInfo.lat longitude:lastRunInfo.lon];;
                
                CLLocationDistance distance = [dist distanceFromLocation:orig];
                if (distance>=KMaxDistance) {
                    //GBLog(@"距离飘星了");
                    errorPointCount++;
                    continue;
                }else if(distance<=KMinDistance) {
                    //GBLog(@"两点的距离太近了");
                    GBLog(@"%@", runInfo);
                    continue;
                }
            }
            if (runInfo.speed>kMaxSpeed) {
                //GBLog(@"速度飘星了");
                errorPointCount++;
                continue;
            }
            
            [tmpList addObject:runInfo];
            
        }
        
        self.runInfoList = [tmpList copy];
        if ((errorPointCount*1.0)/locationList.count >= 0.1) {  //轨迹异常
            BLOCK_EXEC(self.exceptionBlock);
        }
        
    } @catch (NSException *exception) {
    }
}

@end
