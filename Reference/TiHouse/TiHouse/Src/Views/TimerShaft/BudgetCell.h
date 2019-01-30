//
//  BudgetCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@class Budget;
@interface BudgetCell : CommonTableViewCell

@property (nonatomic, retain) Budget *Budget;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *moneyLabel;
@property (nonatomic, retain) UIImageView *icon;

@end
