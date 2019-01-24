//
//  MixClassFile.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixFile.h"

@interface MixClassFile : NSObject

/**
 头文件
 */
@property (nonatomic , strong) MixFile * hFile;

/**
 实现文件
 */
@property (nonatomic , strong) MixFile * mFile;

/**
 类文件名
 */
@property (nonatomic , copy ) NSString * classFileName;

/**
 是否是应用代理
 */
@property (nonatomic , assign , readonly) BOOL isAppDelegate;

/**
 是否是分类
 */
@property (nonatomic , assign , readonly) BOOL isCategory;

@end

