//
//  CourtResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "LocationCoordinateInfo.h"

@interface CourtInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, copy) NSString *courtNameFL;
@property (nonatomic, copy) NSString *courtAddress;
@property (nonatomic, strong) LocationCoordinateInfo *location;
@property (nonatomic, strong) LocationCoordinateInfo *locA;
@property (nonatomic, strong) LocationCoordinateInfo *locB;
@property (nonatomic, strong) LocationCoordinateInfo *locC;
@property (nonatomic, strong) LocationCoordinateInfo *locD;
@property (nonatomic, assign) CourtType courtType;

//请求参数，添加球场时本地配置，
@property (nonatomic, copy) NSString *cityName;

@end

@interface CourtResponseData : YAHActiveObject

@property (nonatomic, strong) NSArray<CourtInfo *> *items;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger flag;  //1：最近球场列表

@end

@interface CourtResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<CourtResponseData *> *data;

@end
