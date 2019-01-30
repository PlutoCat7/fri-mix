//
//  KnowledgeUtil.h
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface KnowledgeUtil : NSObject

+ (NSString *)nameWithKnowType:(KnowType)knowType;

+ (NSString *) compareCurrentTime:(NSTimeInterval)timeInter;

@end
