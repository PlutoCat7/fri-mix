//
//  YAHModelCacheManager.h
//  GB_Football
//
//  Created by yahua on 2017/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYHDiskCache.h"

@interface YAHModelCacheManager : NSObject

/**
 *  @author wangsw, 16-01-25 17:01:36
 *
 *  磁盘缓存
 */
@property (nonatomic, strong, readonly) YYHDiskCache *diskCache;

+ (instancetype)shareInstance;

@end
