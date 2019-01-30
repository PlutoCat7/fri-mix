//
//  PersonProfileHeadView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonProfileHeadViewModel;

@protocol PersonProfileHeadViewDelegate;

@interface PersonProfileHeadView : UIView

@property (nonatomic, strong  ) UIImageView *topIcon;

@property (nonatomic, weak  ) id<PersonProfileHeadViewDelegate> delegate;

- (void)resetViewWithViewModel:(PersonProfileHeadViewModel *)viewModel;

@end

@protocol PersonProfileHeadViewDelegate <NSObject>

- (void)personProfileHeadView:(PersonProfileHeadView *)view clickBackgroundWithViewModel:(PersonProfileHeadViewModel *)viewModel;

- (void)personProfileHeadView:(PersonProfileHeadView *)view clickAvatarWithViewModel:(PersonProfileHeadViewModel *)viewModel;

@end
