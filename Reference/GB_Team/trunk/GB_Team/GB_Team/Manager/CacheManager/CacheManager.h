//
//  CacheManager.h
//  GB_Team
//
//  Created by 王时温 on 2016/12/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)shareInstance;

- (instancetype)initWithCacheName:(NSString *)name;

#pragma mark - 同步方法
- (BOOL)containsObjectForKey:(NSString *)key;

- (id<NSCoding>)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

#pragma mark - 异步方法
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL bContains))block;

- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(NSString *key))block;

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block;
- (void)removeAllObjectsWithBlock:(void(^)())block;

- (void)cacheSize:(void(^)(NSUInteger size))block;

@end
