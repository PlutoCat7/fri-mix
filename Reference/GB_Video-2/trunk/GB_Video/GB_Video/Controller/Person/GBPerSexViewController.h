//
//  GBPerSexViewController.h
//  GB_TransferMarket
//
//  Created by gxd on 17/1/3.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPerSexViewController : GBBaseViewController

@property (nonatomic,copy) void(^saveBlock)(SexType sexType);

- (instancetype)initWithSex:(SexType)sexType;

@end
