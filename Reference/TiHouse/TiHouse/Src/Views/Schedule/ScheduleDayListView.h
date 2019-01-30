//
//  ScheduleDayListView.h
//  TiHouse
//
//  Created by Mstic on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@class ScheduleDayListModel;

@protocol ScheduleDayListViewDelegate;

@interface ScheduleDayListView : BaseView

@property (nonatomic, weak  ) id<ScheduleDayListViewDelegate> delegate;

@end

@protocol ScheduleDayListViewDelegate <NSObject>

- (void)scheduleDayListView:(ScheduleDayListView *)view clickSheduleWithViewModel:(id)viewModel;

@end
