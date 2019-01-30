//
//  YHImagePickerDefines.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KOrientationMaskPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static const NSInteger PreSelectionsToolbarHeight  = 75;

@interface YAHImagePickerDefines : NSObject


@end
