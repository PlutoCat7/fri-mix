//
//  COSBaseViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSBaseViewController : UIViewController

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

@end
