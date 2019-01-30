//
//  GBBaseViewController.h
//  GB_Football
//
//  Created by wsw on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBaseViewController : UIViewController

/**
 *  左上角返回按钮
 *
 *  @param backBlock 点击返回按钮的回调，若nil则默认调用 [self.navigationController popViewControllerAnimated:YES]
 */
- (UIButton *)setupBackButtonWithBlock:(void(^)())backBlock;

#pragma mark - 子类可重写

/** 加载数据 */
- (void)loadData;

/** UI创建 */
- (void)setupUI;

/** 加载数据 */
- (void)loadNetworkData;

/** UI国际化 */
- (void)localizeUI;

/** 获取图片 default nil */
- (UIImage *)getViewShareImage;

@end
