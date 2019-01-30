//
//  MakeOrderPayOptionTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/23.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeOrderPayOptionModel.h"

@interface MakeOrderPayOptionTableViewCell : UITableViewCell

@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, copy) void(^needRefreshTableView)(void);

- (void)refreshWithModel:(MakeOrderPayOptionModel *)model;

@end
