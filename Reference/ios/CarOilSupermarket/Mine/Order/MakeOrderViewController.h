//
//  MakeOrderViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSBaseViewController.h"
#import "ConfirmOrderResponse.h"

@interface MakeOrderViewController : COSBaseViewController

- (instancetype)initWithConfirmOrderInfo:(ConfirmOrderInfo *)info;

@end
