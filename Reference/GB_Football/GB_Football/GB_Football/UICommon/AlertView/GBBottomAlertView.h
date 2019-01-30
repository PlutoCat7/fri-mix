//
//  GBBottomAlertView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//  弹出框从底部弹出

#import <UIKit/UIKit.h>

@interface GBBottomAlertView : UIView

+ (instancetype)showWithTitle:(NSString *)title handler:(void(^)(BOOL isSure))handler;

@end
