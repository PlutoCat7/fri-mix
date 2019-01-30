//
//  OrderListFooterView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/17.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRecordPageResponse.h"

@class OrderListFooterView;
@protocol OrderListFooterViewDelegate <NSObject>

- (void)didClickMenu1:(OrderListFooterView *)footerView;

- (void)didClickMenu2:(OrderListFooterView *)footerView;

@end

@interface OrderListFooterView : UITableViewHeaderFooterView


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) id<OrderListFooterViewDelegate> delegate;
@property (nonatomic, assign) OrderType type;

@end
