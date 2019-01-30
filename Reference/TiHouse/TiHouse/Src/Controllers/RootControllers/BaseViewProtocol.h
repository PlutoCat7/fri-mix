//
//  BaseViewProtocol.h
//  XinJiangTaxiProject
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelProtocol;

@protocol BaseViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <BaseViewModelProtocol>)viewModel;

+ (instancetype)sharedInstanceWithViewModel:(id <BaseViewModelProtocol>)viewModel;

/**
 绑定数据模型
 */
- (void)xl_bindViewModel;

/**
 创建控件视图
 */
- (void)xl_setupViews;

/**
 关闭键盘
 */
- (void)xl_addReturnKeyBoard;

@end
