//
//  YHImagePickerViewController.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAHPhotoModel.h"
@interface YAHImagePickerViewController : UIViewController

@property (nonatomic, copy) void(^dismissBlock)();
@property (nonatomic, copy) void(^failureBlock)(NSError *error);
@property (nonatomic, copy) void(^sucessBlock)(NSArray<YAHPhotoModel *> *assets);

@end
