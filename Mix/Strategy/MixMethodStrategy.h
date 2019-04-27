//
//  MixMethodStrategy.h
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixObject.h"


@interface MixMethodStrategy : NSObject

+ (NSString *)methodFromData:(NSString *)data;

+ (NSArray <NSString *>*)methods:(NSArray <MixObject *>*)objects;

+ (NSArray <NSString *>*)methodsWithPath:(NSString *)path;

@end

