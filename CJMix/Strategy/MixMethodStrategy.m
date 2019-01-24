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
    NSString * methodData = [data copy];
    if ([methodData containsString:@"\n"] && [methodData containsString:@")"] && [methodData containsString:@";"]) {
        NSArray <NSString *>* segmentation = [methodData componentsSeparatedByString:@")"];
        NSString * method = nil;
        if (segmentation.count > 1) {
            method = segmentation[1];
        }
        if (method) {
            if ([method containsString:@";"]) {
                //可能是方法
                if ([method containsString:@":"]) {
                    //带参数方法
                    NSArray <NSString *>* segmentation = [method componentsSeparatedByString:@":"];
                    if (segmentation.count) {
                        method = [NSString stringWithFormat:@"%@:",segmentation[0]];
                    }
                    
                } else {
                    //不带参数方法
                    NSArray <NSString *>* segmentation = [method componentsSeparatedByString:@";"];
                    if (segmentation.count) {
                        method = segmentation[0];
                    }
                }
            }
        }
        
        if ([MixStringStrategy isAlphaNum:method]) {
            return method;
        }
    }
    
    return nil;
}

@end
