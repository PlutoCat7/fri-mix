//
//  MixCacheStrategy.h
//  CJMix
//
//  Created by wangshiwen on 2019/3/16.
//  Copyright © 2019 Chan. All rights reserved.
//  保存缓存数据，类名、方法名 分类名 protocol等

#import <Foundation/Foundation.h>

@interface MixCacheStrategy : NSObject

+ (instancetype)sharedSingleton;

@property (nonatomic , strong) NSMutableDictionary<NSString *, NSString *> *mixClassCache;
@property (nonatomic , strong) NSMutableDictionary<NSString *, NSString *> *mixMethodCache;
@property (nonatomic , strong) NSMutableDictionary<NSString *, NSString *> *mixCategoryCache;
@property (nonatomic , strong) NSMutableDictionary<NSString *, NSString *> *mixProtocolCache;

//保存到文件
- (void)saveCache;

@end
