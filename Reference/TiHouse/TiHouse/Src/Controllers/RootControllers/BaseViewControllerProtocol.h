//
//  BaseViewControllerProtocol.h
//  XinJiangTaxiProject
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelProtocol;

@protocol BaseViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <BaseViewModelProtocol>)viewModel;
/**
 * 绑定视图模型
 */
- (void)xl_bindViewModel;
/**
 * 添加子视图
 */
- (void)xl_addSubviews;
/**
 * 设置导航栏的
 */
- (void)xl_layoutNavigation;
/**
 * 初次获取数据
 */
- (void)xl_getNewData;

/**
 恢复键盘
 */
- (void)recoverKeyboard;

@end
