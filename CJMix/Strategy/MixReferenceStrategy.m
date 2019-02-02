//
//  MixReferenceStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixReferenceStrategy.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "MixObjectStrategy.h"
#import "MixJudgeStrategy.h"
#import "MixStringStrategy.h"
#import "../Model/MixObject.h"
#import "../Model/MixFile.h"
#import "../Config/MixConfig.h"


#define kMinMethodLength 2
#define kDefaultPrefixAndSuffix @"mix"

@implementation MixReferenceStrategy

+ (NSMutableArray <NSString *> *)classNamesWithObjects:(NSArray <MixObject*>*)objects {
    NSMutableArray * classNames = [NSMutableArray arrayWithCapacity:0];
    
    for (MixObject * obj in objects) {
        for (MixClass * class in obj.hClasses) {
            @autoreleasepool {
                NSString * newClassName = [NSString stringWithFormat:@"%@%@",[MixConfig sharedSingleton].mixPrefix,class.className];
                if ([MixJudgeStrategy isLegalNewClassName:newClassName] && ![classNames containsObject:newClassName]) {
                    [classNames addObject:newClassName];
                }
            }
        }
    }
    
    return classNames;
}


+ (NSMutableArray <NSString *> *)methodWithReferenceMethods:(NSArray <NSString*>*)referenceMethods {
    NSMutableArray <NSString *> * methods = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * str in referenceMethods) {
        @autoreleasepool {
            NSString * methodCopy = [NSString stringWithFormat:@"%@",str];
            if ([methodCopy hasPrefix:@"init"]) {
                methodCopy = [methodCopy stringByReplacingOccurrencesOfString:@"init" withString:@""];
            }
            
            if (methodCopy.length <= kMinMethodLength) {
                continue;
            }
            
            NSString * prefix = [MixReferenceStrategy prefixWithMethod:methodCopy];
            NSString * suffix = [MixReferenceStrategy suffixWithMethod:methodCopy];
            suffix = [MixStringStrategy capitalizeTheFirstLetter:suffix];
            methodCopy = [MixStringStrategy capitalizeTheFirstLetter:methodCopy];
            
            NSRange range = [methodCopy rangeOfString:@":"];
            NSString * methodName = nil;
            if (range.location == NSNotFound) {
                methodName = [NSString stringWithFormat:@"%@%@%@",prefix,methodCopy,suffix];
            } else {
                NSString * front = [methodCopy substringToIndex:range.location];
                NSString * back = [methodCopy substringFromIndex:range.location];
                
                methodName = [NSString stringWithFormat:@"%@%@%@%@",prefix,front,suffix,back];
            }
            
            if (![methods containsObject:methodName]) {
                [methods addObject:methodName];
            }
        }
        
    }
    
    
    return methods;
    
}


+ (NSString *)prefixWithMethod:(NSString *)method {
    
    if (![MixConfig sharedSingleton].mixMethodPrefix.count) {
        return kDefaultPrefixAndSuffix;
    }
    
    NSInteger count = arc4random() % [MixConfig sharedSingleton].mixMethodPrefix.count;
    NSString * prefix = [MixConfig sharedSingleton].mixMethodPrefix[count];
    if ([method hasPrefix:prefix]) {
        if ([MixConfig sharedSingleton].mixMethodPrefix.count > 1) {
            [MixReferenceStrategy prefixWithMethod:method];
        } else {
            return kDefaultPrefixAndSuffix;
        }
    }
    return prefix;
}

+ (NSString *)suffixWithMethod:(NSString *)method {
    
    if (![MixConfig sharedSingleton].mixMethodSuffix.count) {
        return kDefaultPrefixAndSuffix;
    }
    
    NSInteger count = arc4random() % [MixConfig sharedSingleton].mixMethodSuffix.count;
    NSString * suffix = [MixConfig sharedSingleton].mixMethodSuffix[count];
    if ([method hasSuffix:suffix]) {
        if ([MixConfig sharedSingleton].mixMethodSuffix.count > 1) {
            [MixReferenceStrategy suffixWithMethod:method];
        } else {
            return kDefaultPrefixAndSuffix;
        }
    }
    return suffix;
}

@end
