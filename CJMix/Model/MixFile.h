//
//  MixFile.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MixFileType) {
    MixFileTypeUnknown,
    MixFileTypeFolder,
    MixFileTypeH,
    MixFileTypeM,
    MixFileTypeMM,
    MixFileTypeProject,
    MixFileTypePodFolder,
    MixFileTypeFramework
};


@interface MixFile : NSObject

/**
 文件目录
 */
@property (nonatomic , copy) NSString * path;

/**
 文件名
 */
@property (nonatomic , copy) NSString * fileName;

/**
 数据
 */
@property (nonatomic , copy) NSString * data;

/**
 文件类型
 */
@property (nonatomic , assign) MixFileType fileType;

/**
 子文件（只有文件夹类型存在）
 */
@property (nonatomic , copy) NSArray <MixFile *>* subFiles;

@end

