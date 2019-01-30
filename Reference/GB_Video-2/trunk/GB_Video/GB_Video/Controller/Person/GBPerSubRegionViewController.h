//
//  GBPerSubRegionViewController.h
//  GB_TransferMarket
//
//  Created by gxd on 17/1/4.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPerSubRegionViewController : GBBaseViewController

@property (nonatomic,copy) BOOL(^saveBlock)(NSInteger cityId);

- (instancetype)initWithRegion:(AreaInfo *)areaInfo cityId:(NSInteger)cityId;

@end
