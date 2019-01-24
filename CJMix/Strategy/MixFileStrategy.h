//
//  MixFileStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixFile.h"

/**
 文件策略
 */
@interface MixFileStrategy : NSObject

/**
 获取文件
 @param path 目标路径
 @return 有效文件
 */
+ (NSArray <MixFile *>*)filesWithPath:(NSString *)path;

/**
 获取头文件和实现文件（会过滤）
 @param files 文件集
 @return .h 和.m文件
 */
+ (NSArray <MixFile *>*)filesToHMFiles:(NSArray <MixFile *>*) files;

/**
 拷贝文件
 @param path 根目录
 @param toPath 拷贝目录
 @param overwrite 是否覆盖
 @param error 错误信息
 @return 成功与否
 */
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error;

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSString *)content;

+ (MixFile *)projectWithFilesWithPath:(NSString *)path;

@end

