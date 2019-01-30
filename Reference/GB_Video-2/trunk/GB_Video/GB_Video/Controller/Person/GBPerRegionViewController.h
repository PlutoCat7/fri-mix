//
//  GBPerRegionViewController.h
//  GB_TransferMarket
//
//  Created by gxd on 17/1/4.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPerRegionViewController : GBBaseViewController

@property (nonatomic,copy) void(^saveBlock)(NSInteger provinceId, NSInteger cityId);

- (instancetype)initWithRegion:(NSInteger)provinceId cityId:(NSInteger)cityId;

@end
