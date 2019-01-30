//
//  BudgetDetailsViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "Budgetpro.h"
@class House ,Budget;
@interface BudgetDetailsPreviewViewController : BaseViewController

@property (nonatomic, retain) Budgetpro *budgetpro;
@property (nonatomic, retain) Budget *budget;
@property (nonatomic, retain) House *house;

@end
