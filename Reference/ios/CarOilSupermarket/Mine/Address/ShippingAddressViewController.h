//
//  ShippingAddressViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSBaseViewController.h"
#import "AddressListResponse.h"

@interface ShippingAddressViewController : COSBaseViewController

- (instancetype)initWithSelectBlock:(void(^)(AddressInfo *info))block;

@end
