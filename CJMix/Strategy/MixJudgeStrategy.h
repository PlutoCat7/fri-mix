//
//  MixJudgeStrategy.h
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixJudgeStrategy : NSObject

+ (BOOL)isSystemClass:(NSString *)className;

+ (BOOL)isLegalClassFrontSymbol:(NSString *)symbol;

+ (BOOL)isLegalClassBackSymbol:(NSString *)symbol;

+ (BOOL)isLegalMethodFrontSymbol:(NSString *)symbol;

+ (BOOL)isLegalMethodBackSymbol:(NSString *)symbol;

+ (BOOL)isLegalMethodFront:(NSString *)front;

+ (BOOL)isShieldWithPath:(NSString *)path;

+ (BOOL)isShieldWithClass:(NSString *)className;

+ (BOOL)isShieldPropertyWithClass:(NSString *)className;

+ (BOOL)isIllegalMethod:(NSString *)method;

+ (BOOL)isShieldWithMethod:(NSString *)method;

+ (BOOL)isLegalNewClassName:(NSString *)className;

@end

