//
//  MixJudgeStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixJudgeStrategy.h"
#import "../Config/MixConfig.h"
#import "../Strategy/MixStringStrategy.h"

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

+ (BOOL)isLegalMethodFrontSymbol:(NSString *)symbol {
    if ([MixStringStrategy isProperty:symbol]) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isLegalMethodBackSymbol:(NSString *)symbol {
    if ([MixStringStrategy isProperty:symbol]) {
        return NO;
    } else {
        return YES;
    }
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

+ (BOOL)isShieldWithClass:(NSString *)className {
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldClass];
    for (NSString * str in array) {
        if ([className isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isShieldWithMethod:(NSString *)method {
    
    if ([method hasPrefix:@"init"]) {
        return YES;
    }
    
    if ([method hasPrefix:@"set"]) {
        return YES;
    }
    
    if (method.length < 5) {
        return YES;
    }

    NSArray * arr = @[@"titleLabel",@"SDExternalCompletionBlock",@"dispatch_block_t",@"CFHTTPMessageRef",@"fillMode",@"allKeys",@"dispatch_time_t",@"addObject",@"sharedInstance",@"isRefreshing",@"longitude",@"latitude",@"stroke",@"sharedManager",@"systemUptime",@"animationType",@"isLoading",@"parser",@"msg_type_",@"isPlaying",@"menuItems",@"maskView",@"firstItem"];
    for (NSString *str in arr) {
        if ([method containsString:str]) {
            return YES;
        }
    }
    
    
    NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldMethods];
    for (NSString * str in array) {
        if ([method isEqualToString:str]) {
            return YES;
        }
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
