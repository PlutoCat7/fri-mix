//
//  GoodsHeaderView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/18.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XXNibBridge.h"
@class GoodsHeaderModel;

@interface GoodsHeaderView : UIView <XXNibBridge>

- (void)refreshWithModel:(GoodsHeaderModel *)model;

@end
