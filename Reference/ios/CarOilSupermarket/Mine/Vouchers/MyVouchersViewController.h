//
//  VouchersViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSBaseViewController.h"
#import "MyVouchersPageResponse.h"

@interface MyVouchersViewController : COSBaseViewController

- (instancetype)initWithSelectInfos:(NSArray<MyVouchersInfo *> *)selectedInfo orderPrice:(CGFloat)orderPrice block:(void(^)(NSArray<MyVouchersInfo *> *infos))block;

@end
