//
//  YAHAlbumModel.h
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/7.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 *  每个相册的模型
 */

@interface YAHAlbumModel : NSObject

/**
 相册名称
 */
@property (copy, nonatomic) NSString *albumName;

/**
 照片数量
 */
@property (assign, nonatomic) NSInteger count;

/**
 封面Asset
 */
@property (strong, nonatomic) PHAsset *asset;

/**
 照片集合对象
 */
@property (strong, nonatomic) PHFetchResult *result;

/**
 选中的个数
 */
@property (assign, nonatomic) NSInteger selectedCount;

@end
