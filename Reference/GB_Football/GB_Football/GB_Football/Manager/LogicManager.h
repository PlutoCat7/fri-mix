//
//  LogicManager.h
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyResponeInfo.h"

@interface LogicManager : NSObject

//根据地区id获取地区详情
+ (AreaInfo *)findAreaWithAreaList:(NSArray<AreaInfo *> *)list areaID:(NSInteger)areaID;

+ (AreaInfo *)findAreaWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId;

//场上位置中文名
+ (NSString *)chinesePositonWithIndex:(NSInteger)index;

//场上位置英文名
+ (NSString *)englishPositonWithIndex:(NSInteger)index;

//根据位置索引获取颜色
+ (UIColor *)positonColorWithIndex:(NSInteger)index;

//获取地址
+ (NSString *)areaStringWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId regionId:(NSInteger)regionId;

//是否设置过用户信息
+ (BOOL)checkExistUserInfo;

// 热点图坐标转换
+ (NSArray *)transformPointArray:(NSArray *)fourPoints origPoints:(NSArray *)origPoints size:(CGSize)size tansX:(BOOL)tansX tansY:(BOOL)transY;

// 手环日常数据解析为DailyInfo list
+ (NSArray<DailyInfo *> *)dailyInfoListWithDic:(NSDictionary *)dataDict;
+ (NSArray<DailyInfo *> *)dailySportInfoListWithDic:(NSDictionary *)dataDict;

// 后台同步手环日常数据
+ (void)asyncToday_DailyData;
+ (void)async7Day_DailyData;

//合成图片
+ (UIImage *)getImageWithHeadImage:(NSArray<UIImage *> *)headImages subviews:(NSArray<UIView *> *)subviews backgroundImage:(UIImage *)backgroundImage;

//检查推送权限是否允许
+ (BOOL)checkIsOpenNotification;
+ (BOOL)checkIsOpenCamera;
+ (BOOL)checkIsOpenAblum;
+ (BOOL)checkIsOpenContact;
@end
