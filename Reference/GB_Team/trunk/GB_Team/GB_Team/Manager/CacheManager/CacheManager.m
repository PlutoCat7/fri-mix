//
//  CacheManager.m
//  GB_Team
//
//  Created by 王时温 on 2016/12/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CacheManager.h"
#import "YYHDiskCache.h"

@interface CacheManager ()

@property (nonatomic, strong) YYHDiskCache *diskCache;

@end

@implementation CacheManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[CacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    return [self initWithCacheName:@"DefaultCacheManager"];
}

- (instancetype)initWithCacheName:(NSString *)name {
    
    self = [super init];
    if (self) {
        _diskCache = [[YYHDiskCache alloc] initWithName:name];
    }
    return self;
}

#pragma mark - 同步方法
- (BOOL)containsObjectForKey:(NSString *)key {
    
    return [self.diskCache containsObjectForKey:key];
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    
    return [self.diskCache objectForKey:key];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    
    [self.diskCache setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    
    [self.diskCache removeObjectForKey:key];
}
- (void)removeAllObjects {
    
    [self.diskCache removeAllObjects];
}

#pragma mark - 异步方法
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL bContains))block {

    [self.diskCache containsObjectForKey:key withBlock:block];
}

- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block {
    
    [self.diskCache objectForKey:key withBlock:block];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    [self.diskCache setObject:object forKey:key withBlock:block];
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    [self.diskCache removeObjectForKey:key withBlock:block];
}

- (void)removeAllObjectsWithBlock:(void(^)())block {
    
    [self.diskCache removeAllObjectsWithBlock:block];
}

- (void)cacheSize:(void(^)(NSUInteger size))block {
    
    [self.diskCache cacheSize:block];
}

@end
