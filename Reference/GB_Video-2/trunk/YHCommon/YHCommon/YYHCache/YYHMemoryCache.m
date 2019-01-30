//
//  YYHMemoryCache.m
//  YYHCacheDemo
//
//  Created by 王时温 on 16/1/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "YYHMemoryCache.h"
#import <UIKit/UIKit.h>
#import <pthread.h>

#define DEFAULT_MAX_COUNT (48)

@interface YYHMemoryCache ()

@property (nonatomic, assign) NSInteger maxCacheCount;
@property (nonatomic, strong) NSMutableArray *cacheKeyList;
@property (nonatomic, strong) NSMutableDictionary *cacheObjectDic;

@property (nonatomic, assign) pthread_mutex_t mutexLock;

@end

@implementation YYHMemoryCache

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clearWhenMemoryLow = YES;
        _maxCacheCount = DEFAULT_MAX_COUNT;
        _cacheKeyList = [NSMutableArray arrayWithCapacity:1];
        _cacheObjectDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        pthread_mutex_init(&_mutexLock, NULL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

#pragma mark - NSNotification

- (void)didReceiveMemoryWarningNotification {
    
    if (_clearWhenMemoryLow) {
        [self removeAllObjects];
    }
}

#pragma mark - Public

- (BOOL)containsObjectForKey:(NSString *)key {
    
    BOOL bContains = NO;
    [self lock];
    bContains = ([_cacheObjectDic objectForKey:key] != nil);
    [self unlock];
    
    return bContains;
}

- (id)objectForKey:(NSString *)key {
    
    id object = nil;
    [self lock];
    object = [_cacheObjectDic objectForKey:key];
    [self unlock];
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    
    if (!key) {
        return;
    }
    
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    [self lock];
    
    if ([_cacheObjectDic objectForKey:key] == object) {
        [self unlock];
        return;
    }
    
    [_cacheKeyList addObject:key];
    if (_cacheKeyList.count>_maxCacheCount) {
        NSString *removeKey = [_cacheKeyList firstObject];
        [_cacheKeyList removeObjectAtIndex:0];
        [_cacheObjectDic removeObjectForKey:removeKey];
    }
    [_cacheObjectDic setObject:object forKey:key];
    
    [self unlock];
}

- (void)removeObjectForKey:(NSString *)key {
    
    [self lock];
    
    if ([_cacheKeyList containsObject:key]) {
        [_cacheKeyList removeObject:key];
        [_cacheObjectDic removeObjectForKey:key];
    }
    
    [self unlock];
}

- (void)removeAllObjects {
    
    [self lock];
    
    [_cacheKeyList removeAllObjects];
    [_cacheObjectDic removeAllObjects];
    
    [self unlock];
}

#pragma mark - Private 

- (void)lock {
    
    pthread_mutex_lock(&_mutexLock);
}

- (void)unlock {
    
    pthread_mutex_unlock(&_mutexLock);
}

@end
