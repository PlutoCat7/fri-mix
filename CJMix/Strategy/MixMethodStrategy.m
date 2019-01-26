//
//  MixMethodStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixMethodStrategy.h"
#import "MixStringStrategy.h"

@implementation MixMethodStrategy

+ (NSString *)methodFromData:(NSString *)data {
    
    //判断无参数方法
    NSRange bracketRange = [data rangeOfString:@")"];
    if (bracketRange.location != NSNotFound) {
        
        NSString * methodStr = [data substringFromIndex:bracketRange.location + bracketRange.length];
        if ([methodStr hasSuffix:@";"]) {
            methodStr = [methodStr substringToIndex:methodStr.length - 1];
        }
        
        if ([MixStringStrategy isAlphaNum:methodStr]) {
            return methodStr;
        }
    }
    
    NSArray <NSString *>* names = [data componentsSeparatedByString:@":"];
    
    if (names.count) {
        NSMutableArray <NSString *>* methodNames = [NSMutableArray arrayWithCapacity:0];
        for (NSString * name in names) {
            NSRange range = [name rangeOfString:@")"];
            if (range.location != NSNotFound) {
                NSString * methodStr = [name substringFromIndex:range.location + range.length];
                if ([MixStringStrategy isAlphaNum:methodStr]) {
                    [methodNames addObject:methodStr];
                }
            } else {
                if ([MixStringStrategy isAlphaNum:name]) {
                    [methodNames addObject:name];
                }
            }
            
        }
        NSString *methodInfo = nil;
        
        if (methodNames.count) {
            methodInfo = [NSString stringWithFormat:@"%@:",[methodNames componentsJoinedByString:@":"]];
        }
        
        
        return methodInfo;
        
    }
    
    
    
    return nil;
}

@end
