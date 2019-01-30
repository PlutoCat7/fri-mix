//
//  GBBaseShareViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@protocol GBBaseShareViewControllerDelegate <NSObject>

//分享界面显示消失回调
- (void)shareViewWillShow;
- (void)shareViewWillHide;

- (void)shareSuccess;
- (void)shareFail;

@end

@protocol GBBaseShareViewControllerDataSource <NSObject>

//默认截屏， 子类可根据需求重写，不包含navigationBar
- (UIImage *)shareImage;

//分享是否带navigationBar  默认为YES
- (BOOL)shareWithNavigationBarImage;

//预截图大小，若shareWithNavigationBarImage 为NO， 则可不实现该方法
- (CGRect)preScreenShotRect;

//是否显示分享按钮 默认为YES
- (BOOL)showShareItem;

@end

@interface GBBaseShareViewController : GBBaseViewController<
GBBaseShareViewControllerDelegate,
GBBaseShareViewControllerDataSource>

//刷新是否显示分享按钮
- (void)resetShareItem;

@end
