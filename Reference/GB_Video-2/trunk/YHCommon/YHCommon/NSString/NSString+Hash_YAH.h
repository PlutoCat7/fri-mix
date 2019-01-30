//
//  NSString+MD5.h
//  YHCommonDemo
//
//  Created by yahua on 16/3/4.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash_YAH)

- (NSString *)MD5;

- (NSString *)hmacSha1WithKey:(NSString*)key;

@end
