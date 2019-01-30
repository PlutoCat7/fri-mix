//
//  OrderListViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSBaseViewController.h"
#import "OrderRecordPageResponse.h"

@interface OrderListViewController : COSBaseViewController

- (instancetype)initWithType:(OrderType)type;

- (void)loadPageData;

@end
