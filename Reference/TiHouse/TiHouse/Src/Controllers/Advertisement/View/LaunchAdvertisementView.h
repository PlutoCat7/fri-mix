//
//  LaunchAdvertisementView.h
//  YouShuLa
//
//  Created by Teen Ma on 2018/4/3.
//  Copyright © 2018年 YouShuLa_IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LaunchAdvertisementViewModel;

@protocol LaunchAdvertisementViewDelegate;

@interface LaunchAdvertisementView : UIView

@property (nonatomic, weak  ) id<LaunchAdvertisementViewDelegate> delegate;

- (void)resetViewWithViewModel:(LaunchAdvertisementViewModel *)viewModel;

@end

@protocol LaunchAdvertisementViewDelegate <NSObject>

- (void)launchAdvertisementView:(LaunchAdvertisementView *)view clickDurationTimerLabelWithViewModel:(LaunchAdvertisementViewModel *)viewModel;

- (void)launchAdvertisementView:(LaunchAdvertisementView *)view clickAdImageViewWithViewModel:(LaunchAdvertisementViewModel *)viewModel;

@end
