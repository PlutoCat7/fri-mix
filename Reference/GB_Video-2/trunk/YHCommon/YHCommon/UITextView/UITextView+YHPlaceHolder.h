//
//  UITextView+YHPlaceHolder.h
//  YHCommon
//
//  Created by gxd on 2018/1/19.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (YHPlaceHolder)

/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *yh_placeHolder;
/**
 *  IQKeyboardManager等第三方框架会读取placeholder属性并创建UIToolbar展示
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *yh_placeHolderColor;

@end
