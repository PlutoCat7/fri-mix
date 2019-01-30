//
//  MakeOrderTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/11.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

@interface MakeOrderTableViewCell : UITableViewCell

- (void)refreshWithModel:(ShoppingCartModel *)model;

@end
