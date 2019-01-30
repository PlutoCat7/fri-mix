//
//  GBBaseViewController.h
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBaseViewController : UIViewController

/**
 *  左上角返回按钮
 *
 *  @param backBlock 点击返回按钮的回调，若nil则默认调用 [self.navigationController popViewControllerAnimated:YES]
 */
- (void)setupBackButtonWithBlock:(void(^)())backBlock;

@end
