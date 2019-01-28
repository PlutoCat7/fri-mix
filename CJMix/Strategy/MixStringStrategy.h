//
//  MixStringStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixStringStrategy : NSObject

+ (BOOL)isAlphaNum:(NSString *)string;

+ (NSString *)filterOutImpurities:(NSString *)string;

+ (BOOL)isProperty:(NSString *)string;

@end
