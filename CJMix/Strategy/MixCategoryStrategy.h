//
//  MixCategoryStrategy.h
//  CJMix
//
//  Created by ChenJie on 2019/1/28.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixObject.h"

@interface MixCategoryStrategy : NSObject

+ (NSArray <MixObject *>*)integrateCategoryMethod:(NSArray <MixObject *>*)objects;


@end
