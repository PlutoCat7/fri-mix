//
//  BudgetPreviewTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@class BudgetOneClass;
@interface BudgetPreviewTableViewCell : CommonTableViewCell

@property (nonatomic, retain) BudgetOneClass *oneClass;


+(CGFloat)GetCellHightWhitOneClass:(BudgetOneClass *)oneClass;

@end
