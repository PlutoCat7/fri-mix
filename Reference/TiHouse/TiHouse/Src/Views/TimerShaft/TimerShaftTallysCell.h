//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "modelTallys.h"
@interface TimerShaftTallysCell : CommonTableViewCell

@property (nonatomic ,retain) modelTallys *modelTallys;
@property (nonatomic, copy) void(^CellBlockClick)(NSInteger tag);

@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标
- (void)setmodelmodelTallys:(modelTallys *)modelTallys needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;
+ (CGFloat)cellHeightWithmodelTallys:(modelTallys *)modelTallys needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;

@end
