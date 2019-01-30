//
//  YHImagePickerCollectionViewController.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YAHAlbumModel;

@interface YAHImagePickerCollectionViewController : UIViewController

@property (nonatomic, copy) void(^sucessBlock)();

- (instancetype)initWith:(YAHAlbumModel *)assetsGroup;

@end
