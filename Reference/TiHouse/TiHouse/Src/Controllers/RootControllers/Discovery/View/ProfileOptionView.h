//
//  ProfileOptionView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/19.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileOptionViewDelegate;

@class ProfileOptionViewModel;

@interface ProfileOptionView : UIView

@property (nonatomic, weak  ) id<ProfileOptionViewDelegate> delegate;

- (void)resetViewWithViewModel:(ProfileOptionViewModel *)viewModel;

@end

@protocol ProfileOptionViewDelegate <NSObject>

- (void)profileOptionView:(ProfileOptionView *)view clickLeftViewWithViewModel:(ProfileOptionViewModel *)viewModel;

- (void)profileOptionView:(ProfileOptionView *)view clickRightViewWithViewModel:(ProfileOptionViewModel *)viewModel;

@end
