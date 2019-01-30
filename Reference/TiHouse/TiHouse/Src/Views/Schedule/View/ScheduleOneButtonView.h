//
//  ScheduleOneButtonView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleOneButtonViewModel;

@protocol ScheduleOneButtonViewDelegate;

@interface ScheduleOneButtonView : UIView

@property (nonatomic, weak  ) id<ScheduleOneButtonViewDelegate> delegate;

- (void)resetViewWithViewModel:(ScheduleOneButtonViewModel *)viewModel;

@end

@protocol ScheduleOneButtonViewDelegate<NSObject>

- (void)scheduleOneButtonView:(ScheduleOneButtonView *)view clickButtonWithViewModel:(ScheduleOneButtonViewModel *)viewModel;

@end
