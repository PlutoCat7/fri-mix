//
//  YYHMemoryCache.h
//  YYHCacheDemo
//
//  Created by 王时温 on 16/1/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYHMemoryCache : NSObject

/**
 *  @author wangsw, 16-01-25 17:01:36
 *
 *  当收到UIApplicationDidReceiveMemoryWarningNotification通知时 是否要清除内存缓存, 默认为YES
 */
@property (nonatomic, assign) BOOL clearWhenMemoryLow;

- (BOOL)containsObjectForKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

@end
