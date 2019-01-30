//
//  THHouseMonthViewController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "House.h"
#import "MonthDairyModel.h"

@interface THHouseMonthViewController : BaseViewController

@property (nonatomic, strong) House *house;
@property (nonatomic, strong) MonthDairyModel *model;

@end
