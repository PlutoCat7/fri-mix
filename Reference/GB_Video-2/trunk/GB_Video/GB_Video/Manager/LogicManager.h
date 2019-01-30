//
//  LogicManager.h
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaInfo.h"

@interface LogicManager : NSObject

//根据地区id获取地区详情
+ (AreaInfo *)findAreaWithAreaList:(NSArray<AreaInfo *> *)list areaID:(NSInteger)areaID;

+ (AreaInfo *)findAreaWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId;

//获取地址
+ (NSString *)areaStringWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId regionId:(NSInteger)regionId;

//检查推送权限是否允许
+ (BOOL)checkIsOpenNotification;
+ (BOOL)checkIsOpenCamera;
+ (BOOL)checkIsOpenAblum;
+ (BOOL)checkIsOpenContact;
@end
