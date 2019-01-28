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

+ (BOOL)isShieldWithPath:(NSString *)path {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldPaths];
    for (NSString * str in array) {
        if ([path hasSuffix:str]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isShieldWitClass:(NSString *)className {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldClass];
    for (NSString * str in array) {
        if ([className isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isShieldWithMethod:(NSString *)method {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldMethods];
    for (NSString * str in array) {
        if ([method isEqualToString:str]) {
            return YES;
        }
    }
    
    if ([method hasPrefix:@"init"]) {
        return YES;
    }
    
    if ([MixJudgeStrategy isSystemClass:method]) {
        return YES;
    }
    
    
    return NO;
}



+ (BOOL)isLegalNewClassName:(NSString *)className {
    BOOL isLegal = YES;
    NSArray * filters = @[@"AppDelegate"];
    if ([filters containsObject:className] || [className containsString:@"("] || [MixJudgeStrategy isSystemClass:className]) {
        isLegal = NO;
    }
    
    return isLegal;
}

@end
