//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@interface TimerShaftNoContentCell : CommonTableViewCell

@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标
@property (nonatomic, copy) void(^CellBlockClick)(void);

@end
