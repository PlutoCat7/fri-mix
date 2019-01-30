//
//  NSDate+GBTimeZone.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GBTimeZone)

//东八区
- (NSDateComponents *)dateComponentsWithGMT8;

- (NSDateComponents *)dateComponentsWithTimeZone:(NSString *)timeZomeString;

+ (NSDate *)dateWithGMT8DateComponents:(NSDateComponents *)dateComponents;
+ (NSDate *)dateWithDateComponents:(NSDateComponents *)dateComponents withTimeZone:(NSString *)timeZomeString;

@end
