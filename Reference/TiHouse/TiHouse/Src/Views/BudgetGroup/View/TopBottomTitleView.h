//
//  TopBottomTitleView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/5/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBottomTitleViewModel;

@protocol TopBottomTitleViewDelegate;

@interface TopBottomTitleView : UIView

@property (nonatomic, weak  ) id<TopBottomTitleViewDelegate> delegate;

- (void)resetViewWithViewModel:(TopBottomTitleViewModel *)viewModel;

@end

@protocol TopBottomTitleViewDelegate <NSObject>

- (void)topBottomTitleView:(TopBottomTitleView *)view clickViewWithViewModel:(TopBottomTitleViewModel *)viewModel;

@end
