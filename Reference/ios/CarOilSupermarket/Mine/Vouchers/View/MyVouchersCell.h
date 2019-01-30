//
//  MyVouchersCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyVouchersCellModel;

@interface MyVouchersCell : UITableViewCell

- (void)refreshWithModel:(MyVouchersCellModel *)model;

@end
