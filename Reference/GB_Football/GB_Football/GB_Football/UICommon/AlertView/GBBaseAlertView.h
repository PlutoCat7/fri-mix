//
//  GBBaseAlertView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBaseAlertView : UIView

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *animationView;

- (void)showPopBox;

- (void)hidePopBox;

@end
