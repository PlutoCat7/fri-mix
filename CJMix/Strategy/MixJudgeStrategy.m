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

+ (BOOL)isShieldPropertyWithClass:(NSString *)className {
    @autoreleasepool {
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldPropertyClass];
        for (NSString * str in array) {
            if ([className isEqualToString:str]) {
                return YES;
            }
        }
        return NO;
    }
}

+ (BOOL)isIllegalMethod:(NSString *)method {
    
    if (![method containsString:@":"]) {
        char fnameStr = [method characterAtIndex:0];
        if (isupper(fnameStr)) {
            return YES;
        }
    }
    
    return NO;
    
}

+ (BOOL)isShieldWithMethod:(NSString *)method {
    @autoreleasepool {
        if ([method hasPrefix:@"init"]) {
            return YES;
        }
        
        if (method.length < 5) {
            return YES;
        }
        
        if ([method hasPrefix:@"set"]) {
            char fnameStr = [method characterAtIndex:3];
            if (isupper(fnameStr)) {
                return YES;
            }
        }
        
        //顽固分子
        NSArray * arr = @[@"parser",@"addObject",@"allKeys",@"isLoading",@"msg_type",@"editable",@"setImageBlock",@"imageBlock",@"ImageBlock"];
        
        for (NSString *str in arr) {
            if ([method containsString:str]) {
//                NSLog(@"xxxxx === %@",str);
                return YES;
            }
        }
        
        NSArray <NSString *> * array = [NSArray arrayWithArray:[MixConfig sharedSingleton].shieldSystemParameter];
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
