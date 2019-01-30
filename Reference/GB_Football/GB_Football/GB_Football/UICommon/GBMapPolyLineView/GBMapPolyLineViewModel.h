//
//  GBMapPolyLineViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

#import "GBMKPolyline.h"
#import "RunInfo.h"

@interface GBMapPolyLineViewModel : NSObject

- (instancetype)initWithRunInfoList:(NSArray<RunInfo *> *)runInfoList;

@property (nonatomic, strong, readonly) NSArray<RunInfo *> *runInfoList;

//地图显示区域
@property (nonatomic, assign, readonly) MACoordinateRegion coordinateRegion;


- (void)getRunPolyLine:(void(^)(GBMKPolyline *runPolyLine))block;

@end
