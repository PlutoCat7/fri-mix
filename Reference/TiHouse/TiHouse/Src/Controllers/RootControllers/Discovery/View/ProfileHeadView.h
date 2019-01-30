//
//  ProfileHeadView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileHeadViewModel;

@protocol ProfileHeadViewDelegate;

@interface ProfileHeadView : UIView

@property (nonatomic, strong  ) UIImageView *topIcon;
@property (nonatomic, weak  ) id<ProfileHeadViewDelegate> delegate;

- (void)resetViewWithViewModel:(ProfileHeadViewModel *)viewModel;

@end

@protocol ProfileHeadViewDelegate <NSObject>

- (void)profileHeadView:(ProfileHeadView *)view clickBackgroundImageViewWithViewModel:(ProfileHeadViewModel *)viewModel;

- (void)profileHeadView:(ProfileHeadView *)view clickTopImageViewWithViewModel:(ProfileHeadViewModel *)viewModel;

- (void)profileHeadView:(ProfileHeadView *)view clickCenterButtonViewWithViewModel:(ProfileHeadViewModel *)viewModel;

- (void)profileHeadView:(ProfileHeadView *)view clickBottomLeftViewWithViewModel:(ProfileHeadViewModel *)viewModel;

- (void)profileHeadView:(ProfileHeadView *)view clickBottomRightViewWithViewModel:(ProfileHeadViewModel *)viewModel;

@end
