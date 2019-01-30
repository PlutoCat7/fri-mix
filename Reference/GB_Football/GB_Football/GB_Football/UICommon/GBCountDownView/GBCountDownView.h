//
//  GBCountDownView.h
//  MTCustomCountDownView
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBCountDownView;
@protocol GBCountDownViewDelegate <NSObject>

- (void)didStartAnimation:(GBCountDownView *)countDownView;
- (void)didFinishAnimation:(GBCountDownView *)countDownView;

@end

@interface GBCountDownView : UIView


@property (nonatomic, weak) id<GBCountDownViewDelegate> delegate;

+ (instancetype)show:(void(^)())handler;

@end
