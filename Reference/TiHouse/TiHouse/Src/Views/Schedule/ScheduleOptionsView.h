//
//  ScheduleOptionsView.h
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "ScheduleOptionsViewModel.h"

@interface ScheduleOptionsView : BaseView

@property (weak, nonatomic) IBOutlet UIButton *btnSchedule;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) ScheduleOptionsViewModel *viewModel;
/**
 设置按钮的显示
 @param name 名称
 */
- (void)setSelectTitle:(NSString *)name;

@end
