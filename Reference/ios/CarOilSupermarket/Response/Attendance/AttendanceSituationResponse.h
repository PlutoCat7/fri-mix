//
//  AttendanceSituationResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

@interface AttendanceDateInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger m;
@property (nonatomic, assign) NSInteger d;

@end

@interface AttendanceSituationInfo : YAHActiveObject

@property (nonatomic, copy) NSString *serverTime; //"2018-01-20 16:19:06"
@property (nonatomic, assign) NSInteger days; //已签到个数
@property (nonatomic, strong) NSArray<AttendanceDateInfo *> *list;
@property (nonatomic, copy) NSString *signInfo;  //"累计签到10天", //签到信息，改用该字段
@property (nonatomic, copy) NSString *withdrawInfo;  //体现记录
//本地属性
@property (nonatomic, strong) NSDate *serverDate;

@end

@interface AttendanceSituationResponse : COSResponseInfo

@property (nonatomic, strong) AttendanceSituationInfo *data;

@end
