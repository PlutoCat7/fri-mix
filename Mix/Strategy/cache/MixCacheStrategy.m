//
//  MixCacheStrategy.m
//  CJMix
//
//  Created by wangshiwen on 2019/3/16.
//  Copyright © 2019 Chan. All rights reserved.
//  

#import "MixCacheStrategy.h"
#import "MixConfig.h"

static NSString *const MixClassCache = @"MixClassCache";
static NSString *const MixMethodCache = @"MixMethodCache";
static NSString *const MixCategoryCache = @"MixCategoryCache";
static NSString *const MixProtocolCache = @"MixProtocolCache";

@implementation MixCacheStrategy

+ (instancetype)sharedSingleton {
    
    static MixCacheStrategy *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

- (void)saveCache {
    
    [NSKeyedArchiver archiveRootObject:self.mixClassCache toFile:[self cacheFlePathWtiheFilaName:MixClassCache]];
    
    [NSKeyedArchiver archiveRootObject:self.mixMethodCache toFile:[self cacheFlePathWtiheFilaName:MixMethodCache]];
    
    [NSKeyedArchiver archiveRootObject:self.mixCategoryCache toFile:[self cacheFlePathWtiheFilaName:MixCategoryCache]];
    
    [NSKeyedArchiver archiveRootObject:self.mixProtocolCache toFile:[self cacheFlePathWtiheFilaName:MixProtocolCache]];
}

- (NSString *)cacheFlePathWtiheFilaName:(NSString *)fileName {
    
    return [NSString stringWithFormat:@"%@/%@",MixConfig.sharedSingleton.argvFolderPath, fileName];
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *, NSString *> *)mixClassCache {
    
    if (!_mixClassCache) {
        NSDictionary * objects = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFlePathWtiheFilaName:MixClassCache]];
        if ([objects isKindOfClass:[NSDictionary class]]) {
            _mixClassCache = [NSMutableDictionary dictionaryWithDictionary:objects];
        } else {
            _mixClassCache = [NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return _mixClassCache;
}

- (NSMutableDictionary<NSString *, NSString *> *)mixMethodCache {
    
    if (!_mixMethodCache) {
        NSDictionary * objects = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFlePathWtiheFilaName:MixMethodCache]];
        if ([objects isKindOfClass:[NSDictionary class]]) {
            _mixMethodCache = [NSMutableDictionary dictionaryWithDictionary:objects];
        } else {
            _mixMethodCache = [NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return _mixMethodCache;
}

- (NSMutableDictionary<NSString *, NSString *> *)mixProtocolCache {
    
    if (!_mixProtocolCache) {
        NSDictionary * objects = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFlePathWtiheFilaName:MixProtocolCache]];
        if ([objects isKindOfClass:[NSDictionary class]]) {
            _mixProtocolCache = [NSMutableDictionary dictionaryWithDictionary:objects];
        } else {
            _mixProtocolCache = [NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return _mixProtocolCache;
}

- (NSMutableDictionary<NSString *, NSString *> *)mixCategoryCache {
    
    if (!_mixCategoryCache) {
        NSDictionary * objects = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheFlePathWtiheFilaName:MixCategoryCache]];
        if ([objects isKindOfClass:[NSDictionary class]]) {
            _mixCategoryCache = [NSMutableDictionary dictionaryWithDictionary:objects];
        } else {
            _mixCategoryCache = [NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return _mixCategoryCache;
}

@end
