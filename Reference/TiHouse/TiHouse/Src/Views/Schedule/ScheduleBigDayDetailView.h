//
//  ScheduleBigDayDetailView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleBigDayDetailViewModel;
@class ScheduleDetailViewModel;
@class ScheduleOneButtonViewModel;
@class AdverHeadViewModel;

@protocol ScheduleBigDayDetailViewDelegate;

@interface ScheduleBigDayDetailView : UIView

@property (nonatomic, weak  ) id<ScheduleBigDayDetailViewDelegate> delegate;

- (void)resetViewWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel;

@end

@protocol ScheduleBigDayDetailViewDelegate <NSObject>

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickTopViewWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel;

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickScheduleCellWithViewModel:(ScheduleDetailViewModel *)viewModel;

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view clickBottomButtonWithViewModel:(ScheduleBigDayDetailViewModel *)viewModel;

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view swipeToFinishedWithViewModel:(ScheduleDetailViewModel *)viewModel;

- (void)scheduleBigDayDetailView:(ScheduleBigDayDetailView *)view swipeToDeleteWithViewModel:(ScheduleDetailViewModel *)viewModel;

@end
