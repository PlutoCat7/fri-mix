//
//  MixJudgeStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixJudgeStrategy.h"
#import "../Config/MixConfig.h"


@implementation MixJudgeStrategy

+ (BOOL)isSystemClass:(NSString *)className {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].systemPrefixs];
    for (NSString * str in array) {
        if ([className hasPrefix:str]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isLegalClassFrontSymbol:(NSString *)symbol {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].legalClassFrontSymbols];
    for (NSString * str in array) {
        if ([symbol isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isLegalClassBackSymbol:(NSString *)symbol {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].legalClassBackSymbols];
    for (NSString * str in array) {
        if ([symbol isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

@end
