//
//  YAHModelCacheManager.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHModelCacheManager.h"

@interface YAHModelCacheManager ()

@property (nonatomic, strong, readwrite) YYHDiskCache *diskCache;

@end

@implementation YAHModelCacheManager

+ (instancetype)shareInstance {
    
    static YAHModelCacheManager *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YAHModelCacheManager alloc] init];
    });
    return cache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _diskCache = [[YYHDiskCache alloc] initWithName:@"T-Goal" rootPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    }
    return self;
}

@end
