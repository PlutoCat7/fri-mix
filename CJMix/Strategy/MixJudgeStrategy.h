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

+ (BOOL)isShieldWithPath:(NSString *)path;

+ (BOOL)isLikeCategory:(NSString *)fileName;

+ (BOOL)isLegalNewClassName:(NSString *)className;

@end

