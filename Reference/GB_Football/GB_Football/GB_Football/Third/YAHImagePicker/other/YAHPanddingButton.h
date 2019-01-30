//
//  UIPanddingButton.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAHPanddingButton : UIButton

@property (nonatomic) UIEdgeInsets backgroundImageInsets;

//用frame和文字边距初始化
- (id)initWithFrame:(CGRect)frame backgroundImageInsets:(UIEdgeInsets)insets;

@end
