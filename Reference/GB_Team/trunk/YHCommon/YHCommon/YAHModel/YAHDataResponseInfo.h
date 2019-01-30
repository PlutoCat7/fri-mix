//
//  YHDataResponseInfo.h
//  YCZZ_iPad
//
//  Created by wangsw on 15/11/25.
//  Copyright © 2015年 com.nd.hy. All rights reserved.
//

#import "YAHActiveObject.h"

@interface YAHDataResponseInfo : YAHActiveObject

#pragma mark - 需子类重写
/**
 *  网络请求是否有效
 *
 *  @return YES json数据有效
 */
- (BOOL)isAdapterSuccess;

/**
 *  网络请求返回code
 *
 */
- (NSInteger)responseCode;

/**
 *  网络请求提示文本
 *
 */
- (NSString *)responseMsg;

/**
 *  获取缓存的key，默认为类名，如有需要可重写
 *
 *  @return cache key
 */
- (NSString *)getCacheKey;

#pragma mark - 数据处理

/**
 *  解析json数据
 *
 *  @param data  支持nsdata nsstring nsarray nsdictionary
 *  @param complete 解析完成回调
 */
+ (void)analyseWithData:(id)data complete:(void (^)(__kindof YAHDataResponseInfo *result, NSString *errMsg))complete;

/**
 *  加载缓存
 *
 */
+ (__kindof YAHDataResponseInfo *)loadCache;

/**
 *  存储缓存， 需要手动调用  默认不缓存数据
 *
 *  @return YES 表示成功
 */
- (BOOL)saveCache;

/**
 *  清除缓存数据
 *
 *  @return YES 表示成功
 */
- (BOOL)clearCache;

@end
