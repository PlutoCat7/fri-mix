//
//  VouchersBuyCollectionViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVouchersBuyCollectionViewCellWidth (167*kAppScale)
#define kVouchersBuyCollectionViewCellHeight (118*kAppScale)

@class VouchersBuyCellModel;
@class VouchersBuyCollectionViewCell;

@protocol VouchersBuyCollectionViewCellDelegate <NSObject>

- (void)didDeleteButtonWithCell:(VouchersBuyCollectionViewCell *)cell;

- (void)didAddButtonWithCell:(VouchersBuyCollectionViewCell *)cell;

@end

@interface VouchersBuyCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<VouchersBuyCollectionViewCellDelegate> delegate;

- (void)refreshWithModel:(VouchersBuyCellModel *)model;

@end
