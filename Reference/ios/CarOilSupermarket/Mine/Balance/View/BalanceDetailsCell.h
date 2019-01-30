//
//  BalanceDetailsCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BalanceDetailsCellModel;

#define kBalanceDetailsCellHeight (75*kAppScale)

@interface BalanceDetailsCell : UITableViewCell

- (void)refreshWithModel:(BalanceDetailsCellModel *)model;

@end
