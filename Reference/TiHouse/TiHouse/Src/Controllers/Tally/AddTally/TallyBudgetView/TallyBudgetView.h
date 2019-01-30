//
//  TallyBudget
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//
// 

#import <UIKit/UIKit.h>
@class Budget;
//typedef void(^SelectedBlock)(NSInteger index, NSString *name);
typedef void(^selectedBlock)(Budget *budget);

@interface TallyBudgetView : UIView
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *budgetArray;
//@property (copy, nonatomic) SelectedBlock selectedBlock;
@property (copy, nonatomic) selectedBlock selectedBlock;

- (void)show;

- (void)bgViewTapAction;

@end
