//
//  NewScheduleView.h
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "House.h"

@interface NewScheduleView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel;

@property (strong, nonatomic) House * house;

/**
 * 设置提醒时间
 */
-(void)makeRemindTimeContent:(NSString *)value withIndex:(NSInteger )index;

/**
 * 设置提醒的人
 */
-(void)makeRemindPeopleContent:(NSArray *)valueArray;

- (void)setRemindPeople;

@end
