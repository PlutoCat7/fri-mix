//
//  YHDataResponseInfo.m
//  YCZZ_iPad
//
//  Created by wangsw on 15/11/25.
//  Copyright © 2015年 com.nd.hy. All rights reserved.
//

#import "YAHDataResponseInfo.h"
#import "YAHJSONAdapter.h"
#import "YAHModelCacheManager.h"

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

@implementation YAHDataResponseInfo


- (BOOL)isAdapterSuccess {
    
    return NO;
}

- (NSInteger)responseCode {
    
    return 0;
}

- (NSString *)responseMsg {
    
    return @"";
}

+ (void)analyseWithData:(id)data complete:(void (^)(__kindof YAHDataResponseInfo *result, NSError *errMor))complete {
    
    __kindof YAHDataResponseInfo *result = [YAHJSONAdapter objectFromJsonData:data objectClass:[self class]];
    if (result && [result isAdapterSuccess] ) {
        BLOCK_EXEC(complete, result, nil);
    }else {
        NSString *errMsg = [result responseMsg];
        errMsg = (errMsg)?:LS(@"network.data.error");
        BLOCK_EXEC(complete, nil, [NSError errorWithDomain:errMsg code:[result responseCode] userInfo:nil]);
    }
    
}

+ (__kindof YAHDataResponseInfo *)loadCache {
    
    YAHDataResponseInfo *tmpObject = [[[self class] alloc] init];
    YAHDataResponseInfo *result = (YAHDataResponseInfo *)[[YAHModelCacheManager shareInstance].diskCache objectForKey:[tmpObject getCacheKey]];

    return result;
}

+ (__kindof YAHDataResponseInfo *)loadCacheWithKey:(NSString *)key {
    
    //加类名
    key = [NSString stringWithFormat:@"%@_%@", [[self class] description], key];
    return (YAHDataResponseInfo *)[[YAHModelCacheManager shareInstance].diskCache objectForKey:key];
}

+ (void)loadCacheWithKey:(NSString *)key withBlock:(void(^)(NSString *key, __kindof YAHDataResponseInfo *object))block {
    
    //加类名
    key = [NSString stringWithFormat:@"%@_%@", [[self class] description], key];
    [[YAHModelCacheManager shareInstance].diskCache objectForKey:key withBlock:^(NSString *key, id<NSCoding> object) {
        
        BLOCK_EXEC(block, key, (YAHDataResponseInfo *)object);
    }];
}

- (NSString *)getCacheKey {
    
    NSString *key = [[self class] description];
    return key;
}

- (BOOL)saveCache {
    
    [[YAHModelCacheManager shareInstance].diskCache setObject:self forKey:[self getCacheKey]];
    return YES;
}

- (BOOL)clearCache {
    
    [[YAHModelCacheManager shareInstance].diskCache removeObjectForKey:[self getCacheKey]];

    return YES;
}

#pragma mark - Private

//归档path
- (NSString *)p_archiverFilePath {
    
    NSString *folderName =[NSString stringWithFormat:@"Archiver"];
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *optionPath = [documentPath stringByAppendingPathComponent:folderName];
    if (![fm fileExistsAtPath:optionPath]) {
        [fm createDirectoryAtPath:optionPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [NSString stringWithFormat:@"%@/%@", optionPath, [self getCacheKey]];
}

@end
