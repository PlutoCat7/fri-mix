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
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].systemPrefixs];
        for (NSString * str in array) {
            if ([className hasPrefix:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isLegalClassFrontSymbol:(NSString *)symbol {
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].legalClassFrontSymbols];
        for (NSString * str in array) {
            if ([symbol isEqualToString:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isLegalClassBackSymbol:(NSString *)symbol {
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].legalClassBackSymbols];
        for (NSString * str in array) {
            if ([symbol isEqualToString:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isLegalMethodFrontSymbol:(NSString *)symbol {
    @autoreleasepool {
        if ([MixStringStrategy isAlphaNum:symbol]) {
            return NO;
        } else {
            return YES;
        }
    }
}

+ (BOOL)isLegalMethodBackSymbol:(NSString *)symbol {
    @autoreleasepool {
        if ([MixStringStrategy isAlphaNum:symbol]) {
            return NO;
        } else {
            return YES;
        }
    }
}

+ (BOOL)isShieldWithPath:(NSString *)path {
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldPaths];
        for (NSString * str in array) {
            if ([path hasSuffix:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isShieldWithClass:(NSString *)className {
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldClass];
        for (NSString * str in array) {
            if ([className isEqualToString:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isShieldWithMethod:(NSString *)method {
    @autoreleasepool {
        if ([method hasPrefix:@"init"]) {
            return YES;
        }
        
        if ([method hasPrefix:@"set"]) {
            return YES;
        }
        
        if (method.length < 5) {
            return YES;
        }
        
        NSArray * arr = @[@"titleLabel",@"SDExternalCompletionBlock",@"dispatch_block_t",@"CFHTTPMessageRef",@"fillMode",@"allKeys",@"dispatch_time_t",@"addObject",@"sharedInstance",@"isRefreshing",@"longitude",@"latitude",@"stroke",@"sharedManager",@"systemUptime",@"animationType",@"isLoading",@"parser",@"msg_type_",@"isPlaying",@"menuItems",@"maskView",@"firstItem",@"kCCParamError"];
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
}



+ (BOOL)isLegalNewClassName:(NSString *)className {
    @autoreleasepool {
        BOOL isLegal = YES;
        NSArray * filters = @[@"AppDelegate"];
        if ([filters containsObject:className] || [className containsString:@"("] || [MixJudgeStrategy isSystemClass:className]) {
            isLegal = NO;
        }
        
        return isLegal;
    }
}


+ (BOOL)isLegalMethodFront:(NSString *)string {
    
    NSString * front = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    front = [front stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!front.length) {
        return NO;
    }
    front = [front substringFromIndex:front.length-1];
    if ([front isEqualToString:@";"] || [front isEqualToString:@"}"]) {
        return YES;
    } else if ([string containsString:@"@interface"] || [string containsString:@"@implementation"] ) {
        return YES;
    }
    return NO;
    
}

@end
