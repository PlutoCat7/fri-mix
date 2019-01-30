//
//  BluUtility.h
//  GB_Football
//
//  Created by weilai on 16/4/10.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluUtility : NSObject

// 计算日常模式的数据
+ (NSArray *) calDaily:(NSDictionary *)dailyData weight:(float)weight height:(float)height sex:(int)sex;

+ (NSArray *) calDailySport:(NSDictionary *)dailySportData weight:(float)weight height:(float)height sex:(int)sex;

+ (void)setUUIDString:(NSString *)uuid withKey:(NSString *)mac;
+ (NSString *)getUUIDStringWithKey:(NSString *)mac;

@end
