//
//  NSDate+TimeZone.h
//  YHCommon
//
//  Created by gxd on 2018/1/19.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeZone)

//东八区
- (NSDateComponents *)dateComponentsWithGMT8;

- (NSDateComponents *)dateComponentsWithTimeZone:(NSString *)timeZomeString;

+ (NSDate *)dateWithGMT8DateComponents:(NSDateComponents *)dateComponents;
+ (NSDate *)dateWithDateComponents:(NSDateComponents *)dateComponents withTimeZone:(NSString *)timeZomeString;

@end
