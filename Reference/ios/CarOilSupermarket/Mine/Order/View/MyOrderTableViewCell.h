//
//  MyOrderTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRecordPageResponse.h"

@interface MyOrderTableViewCell : UITableViewCell

- (void)refreshWithModel:(OrderRecordGoodsInfo *)model;

@end
