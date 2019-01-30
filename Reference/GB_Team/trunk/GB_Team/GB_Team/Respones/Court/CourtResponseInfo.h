//
//  CourtResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "LocationCoordinateInfo.h"

@interface CourtInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, copy) NSString *courtNameFL;
@property (nonatomic, copy) NSString *courtAddress;
//球场位置
@property (nonatomic, strong) LocationCoordinateInfo *location;
//球场中心点
@property (nonatomic, strong) LocationCoordinateInfo *center;
//球场实际四点位置
@property (nonatomic, strong) LocationCoordinateInfo *locA;
@property (nonatomic, strong) LocationCoordinateInfo *locB;
@property (nonatomic, strong) LocationCoordinateInfo *locC;
@property (nonatomic, strong) LocationCoordinateInfo *locD;
//最小外切矩形
@property (nonatomic, strong) LocationCoordinateInfo *point_a;
@property (nonatomic, strong) LocationCoordinateInfo *point_b;
@property (nonatomic, strong) LocationCoordinateInfo *point_c;
@property (nonatomic, strong) LocationCoordinateInfo *point_d;
@property (nonatomic, assign) CourtType courtType;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@end

@interface CourtResponseData : YAHActiveObject

@property (nonatomic, strong) NSArray<CourtInfo *> *items;
@property (nonatomic, copy) NSString *name;

@end

@interface CourtResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<CourtResponseData *> *data;

@end
