//
//  MixTool.h
//  CJMix
//
//  Created by wangsw on 2019/3/19.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixTool : NSObject

/**
 移除已使用的文件

 @param referenceFileWithPath 参考文件路径
 @param usedCachePath 使用过的缓存文件路径
 */
+ (void)removeReferenceFileWithPath:(NSString *)referenceFileWithPath usedCachePath:(NSString *)usedCachePath;

/**
 将fromFilePath的文件copy到referenceFileWithPath中

 @param referenceFileWithPath 参考文件路径
 @param fromFilePath 从该文件copy到referenceFileWithPath中
 */
+ (void)moveReferenceFileWithPath:(NSString *)referenceFileWithPath fromFilePath:(NSString *)fromFilePath;

/**
 将一个文件的文案随机插入另外一个文件中

 @param referenceFilePath 参考文件目录
 @param toFilePath 目标文件路径
 */
+ (void)insertMixLocalizable:(NSString *)referenceFilePath toFilePath:(NSString *)toFilePath;

@end
