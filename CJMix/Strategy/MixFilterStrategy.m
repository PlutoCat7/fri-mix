//
//  MixFilterStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixFilterStrategy.h"

@implementation MixFilterStrategy

+ (BOOL)isSystemClass:(NSString *)className {
    NSArray <NSString *> * systemClassPrefixs = @[@"UI",@"CA",@"NS"];
    for (NSString * prefix in systemClassPrefixs) {
        if ([className hasPrefix:prefix]) {
            return YES;
        }
    }
    return NO;
}

@end
