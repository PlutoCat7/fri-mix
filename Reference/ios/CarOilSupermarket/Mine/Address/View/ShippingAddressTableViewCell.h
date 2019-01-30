//
//  ShippingAddressTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@class ShippingAddressTableViewCell;
@protocol ShippingAddressTableViewCellDelegate <NSObject>

- (void)didClickDefaultCell:(ShippingAddressTableViewCell *)cell;
- (void)didClickEditCell:(ShippingAddressTableViewCell *)cell;
- (void)didClickDeleteCell:(ShippingAddressTableViewCell *)cell;

@end

@interface ShippingAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShippingAddressTableViewCellDelegate> delegate;

- (void)refreshWithAddressModel:(AddressModel *)model;

@end
