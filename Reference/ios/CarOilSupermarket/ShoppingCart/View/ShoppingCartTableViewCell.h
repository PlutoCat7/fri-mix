//
//  ShoppingCartTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

@class ShoppingCartTableViewCell;
@protocol ShoppingCartTableViewCellDelegate <NSObject>

- (void)addGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell;
- (void)reduceGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell;

- (void)changeGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell count:(NSInteger)count;

- (void)goodDidSelectWithCell:(ShoppingCartTableViewCell *)cell;

@end

@interface ShoppingCartTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShoppingCartTableViewCellDelegate> delegate;

- (void)refreshWithModel:(ShoppingCartModel *)model;

@end
