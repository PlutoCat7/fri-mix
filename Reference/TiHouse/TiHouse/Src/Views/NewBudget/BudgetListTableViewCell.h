//
//  BudgetListTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@class Budget;
typedef NS_ENUM(NSInteger,BudgetListCellBtnRespondType) {
    BudgetListCellBtnRespondTypeDelete = 0,
    BudgetListCellBtnRespondTypeLock,
    BudgetListCellBtnRespondTypeChange
};

@protocol BudgetListTableViewCellDelegate<NSObject>

-(void)BudgetListCellBtnCkickRespondType:(BudgetListCellBtnRespondType)Style cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BudgetListTableViewCell : CommonTableViewCell

@property (nonatomic, retain) Budget *budget;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, weak) id<BudgetListTableViewCellDelegate> delagate;

@end
