//
//  MixReferenceStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixReferenceStrategy.h"
#import "../Model/MixObject.h"
#import "../Model/MixFile.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "MixObjectStrategy.h"
#import "MixJudgeStrategy.h"
#import "../Config/MixConfig.h"
#import "MixStringStrategy.h"

@implementation MixReferenceStrategy

+ (NSMutableArray <NSString *> *)classNamesWithObjects:(NSArray <MixObject*>*)objects {
    NSMutableArray * classNames = [NSMutableArray arrayWithCapacity:0];
    [objects enumerateObjectsUsingBlock:^(MixObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (MixClass * class in obj.hClasses) {
            NSString * newClassName = [NSString stringWithFormat:@"%@%@",[MixConfig sharedSingleton].mixPrefix,class.className];
            if ([MixJudgeStrategy isLegalNewClassName:newClassName] && ![classNames containsObject:newClassName]) {
                [classNames addObject:newClassName];
            }
        }
    }];
    
    return classNames;
}

+ (NSMutableArray <NSString *> *)methodWithObjects:(NSArray <MixObject*>*)objects {
    
    NSMutableArray <NSString *> * methods = [NSMutableArray arrayWithCapacity:0];
    
    [objects enumerateObjectsUsingBlock:^(MixObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (MixClass * class in obj.hClasses) {
            
            NSMutableArray * blend = [NSMutableArray arrayWithCapacity:0];
            [blend addObjectsFromArray:class.method.classMethods];
            [blend addObjectsFromArray:class.method.exampleMethods];
            
            for (NSString * method in blend) {
                
                NSString * prefix = [MixReferenceStrategy prefixWithMethod:method];
                NSString * suffix = [MixReferenceStrategy suffixWithMethod:method];
                suffix = [MixStringStrategy capitalizeTheFirstLetter:suffix];
                NSString * methodCopy = [MixStringStrategy capitalizeTheFirstLetter:method];
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
        
        
    }];
    return methods;
    
}

+ (NSString *)prefixWithMethod:(NSString *)method {
    NSInteger count = arc4random() % [MixConfig sharedSingleton].mixMethodPrefix.count;
    NSString * prefix = [MixConfig sharedSingleton].mixMethodPrefix[count];
    if ([method hasPrefix:prefix]) {
        [MixReferenceStrategy prefixWithMethod:method];
    }
    return prefix;
}

+ (NSString *)suffixWithMethod:(NSString *)method {
    NSInteger count = arc4random() % [MixConfig sharedSingleton].mixMethodSuffix.count;
    NSString * suffix = [MixConfig sharedSingleton].mixMethodSuffix[count];
    if ([method hasSuffix:suffix]) {
        [MixReferenceStrategy prefixWithMethod:method];
    }
    return suffix;
}

@end
