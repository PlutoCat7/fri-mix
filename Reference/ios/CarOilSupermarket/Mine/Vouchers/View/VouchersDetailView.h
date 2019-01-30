//
//  VouchersDetailView.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VouchersBuyCellModel;
@class VouchersDetailView;

@protocol VouchersDetailViewDelegate<NSObject>

- (void)vouchersDetailViewdidAdd:(VouchersBuyCellModel *)cellModel view:(VouchersDetailView *)vouchersDetailView;

@end

@interface VouchersDetailView : UIView

@property (nonatomic, weak) id<VouchersDetailViewDelegate> delegate;

+ (void)showWithModel:(VouchersBuyCellModel *)model delegate:(id)delegate;

- (void)refreshWithModel:(VouchersBuyCellModel *)model;

@end
