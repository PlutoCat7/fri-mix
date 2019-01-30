//
//  YYHCache.m
//  YYHCacheDemo
//
//  Created by 王时温 on 16/1/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "YYHCache.h"
#import "YYHMemoryCache.h"
#import "YYHDiskCache.h"

@interface YYHCache ()

@property (nonatomic, strong, readwrite) YYHMemoryCache *memoryCache;
@property (nonatomic, strong, readwrite) YYHDiskCache *diskCache;
@property (nonatomic, copy, readwrite) NSString *name;

@end

@implementation YYHCache

+ (instancetype)shareInstance {
    
    static YYHCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYHCache alloc] initWithName:@"YYHCache"];
    });
    return cache;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name rootPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
}

- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath {
    
    self = [super init];
    if (self) {
        _name = name;
        _memoryCache = [YYHMemoryCache new];
        _diskCache = [[YYHDiskCache alloc] initWithName:name rootPath:rootPath];
    }
    return self;
}

#pragma mark - Public

- (BOOL)containsObjectForKey:(NSString *)key {
    
    return [_memoryCache containsObjectForKey:key] || [_diskCache containsObjectForKey:key];
}

- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL bContains))block {
    
    if (!block) {
        return;
    }
    if ([_memoryCache containsObjectForKey:key]) {
        block(key, YES);
    }else {
        [_diskCache containsObjectForKey:key withBlock:block];
    }
}


- (id<NSCoding>)objectForKey:(NSString *)key {
    
    id object = [_memoryCache objectForKey:key];
    if (!object) {
        object = [_diskCache objectForKey:key];
        if (object) {
            [_memoryCache setObject:object forKey:key];
        }
    }
    return object;
}

- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block {
    
    if (!block) return;
    id<NSCoding> object = [_memoryCache objectForKey:key];
    if (object) {
        block(key, object);
    } else {
        [_diskCache objectForKey:key withBlock:block];
    }
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    
    [_memoryCache setObject:object forKey:key];
    [_diskCache setObject:object forKey:key];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    if (!block) {
        return;
    }
    
    [_memoryCache setObject:object forKey:key];
    [_diskCache setObject:object forKey:key withBlock:block];
}

- (void)removeObjectForKey:(NSString *)key {
    
    [_memoryCache removeObjectForKey:key];
    [_diskCache removeObjectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
    if (!block) {
        return;
    }
    [_memoryCache removeObjectForKey:key];
    [_diskCache removeObjectForKey:key withBlock:block];
}

- (void)removeAllObjects {
    
    [_memoryCache removeAllObjects];
    [_diskCache removeAllObjects];
}

- (void)removeAllObjectsWithBlock:(void(^)())block {
    
    if (!block) {
        return;
    }
    [_memoryCache removeAllObjects];
    [_diskCache removeAllObjectsWithBlock:block];
}

- (void)cacheSize:(void(^)(NSUInteger size))block {
    
    if(!block) return;
    [_diskCache cacheSize:block];
}

@end
