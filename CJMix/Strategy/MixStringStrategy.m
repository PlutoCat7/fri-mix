//
//  MixStringStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixStringStrategy.h"

@implementation MixStringStrategy

+ (BOOL)isAlphaNum:(NSString *)string {
    NSString *regex =@"[a-zA-Z0-9_]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
    
}

+ (NSString *)filterOutImpurities:(NSString *)string {
    NSString * newData = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newData = [newData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newData = [newData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return newData;
}

@end
