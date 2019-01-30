//
//  TallyHelper.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TallyHelper : NSObject

// 获取文字宽度
+ (CGSize)labelSize:(NSString *)contentStr font:(UIFont *)font height:(CGFloat)height;

// 是否包含日期，匹配：xx月xx日、xx月xx号
+ (BOOL)isContainDeteStr:(NSString *)str;

// 获取当前时间格式化
+ (NSString *)getTimeNowWithFormat:(NSString *)dateFormat;
// 根据date来获取日期
+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format;
// 根据timestamp来获取日期
+ (NSString *)formatTime:(NSTimeInterval)timestamp formatWith:(NSString *)format;

+ (NSDate *)currentDate;

@end
