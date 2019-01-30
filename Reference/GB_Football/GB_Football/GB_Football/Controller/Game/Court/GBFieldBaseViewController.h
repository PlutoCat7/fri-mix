//
//  GBFieldBaseViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBFieldBaseViewController : GBBaseViewController


/**
 初始化

 @param pageIndex 显示的item 0:系统球场  1:我的球场

 */
- (instancetype)initWithPageIndex:(NSInteger)pageIndex;

@end
