//
//  MixCategoryStrategy.h
//  CJMix
//
//  Created by wangshiwen on 2019/1/29.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MixCategoryStrategy : NSObject

//旧分类与新分类
@property (nonatomic, strong) NSMutableDictionary *resetDict;

+ (instancetype)shareInstance;

- (BOOL)start;

- (NSString *)getNewCategoryNameWithOld:(NSString *)old;

@end

NS_ASSUME_NONNULL_END
