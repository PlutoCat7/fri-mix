//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TunerBudget.h"
@interface TimerShaftBudgetCell : CommonTableViewCell

@property (nonatomic ,retain) TunerBudget *tunerBudget;
@property (nonatomic, copy) void(^CellBlockClick)(NSInteger tag);

@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标
- (void)setmodelTunerBudget:(TunerBudget *)tunerBudget needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;
+ (CGFloat)cellHeightWithTunerBudget:(TunerBudget *)tunerBudget needTopView:(BOOL)needTopView  needBottomView:(BOOL)needBottomView;

@end
