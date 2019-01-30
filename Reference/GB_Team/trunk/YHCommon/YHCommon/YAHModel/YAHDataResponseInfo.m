//
//  YHDataResponseInfo.m
//  YCZZ_iPad
//
//  Created by wangsw on 15/11/25.
//  Copyright © 2015年 com.nd.hy. All rights reserved.
//

#import "YAHDataResponseInfo.h"
#import "YAHJSONAdapter.h"

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

+ (void)analyseWithData:(id)data complete:(void (^)(__kindof YAHDataResponseInfo *result, NSString *errMsg))complete {
    
    __kindof YAHDataResponseInfo *result = [YAHJSONAdapter objectFromJsonData:data objectClass:[self class]];
    if (result && [result isAdapterSuccess] ) {
        BLOCK_EXEC(complete, result, nil);
    }else {
        NSString *errMsg = [result responseMsg];
        errMsg = (errMsg)?:@"数据解析失败！！！";
        BLOCK_EXEC(complete, nil, errMsg);
    }
    
}

+ (__kindof YAHDataResponseInfo *)loadCache; {
    
    @try {
        YAHDataResponseInfo *object = [[[self class] alloc] init];
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:[object p_archiverFilePath]];
        return object;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (NSString *)getCacheKey {
    
    NSString *key = [[self class] description];
    return key;
}

- (BOOL)saveCache {
    
    @try {
        [NSKeyedArchiver archiveRootObject:self toFile:[self p_archiverFilePath]];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (BOOL)clearCache {
    
    return [[NSFileManager defaultManager] removeItemAtPath:[self p_archiverFilePath] error:nil];
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
