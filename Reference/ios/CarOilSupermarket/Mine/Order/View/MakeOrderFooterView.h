//
//  MakeOrderFooterView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/15.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeOrderFooterModel.h"

@interface MakeOrderFooterView : UITableViewHeaderFooterView

- (void)refreshWithModel:(MakeOrderFooterModel *)model;

@end
