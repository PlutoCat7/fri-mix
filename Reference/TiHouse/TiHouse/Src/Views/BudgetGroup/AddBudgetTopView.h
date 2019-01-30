//
//  BottomBtnView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BudgetThreeClass;
@interface AddBudgetTopView : UIView

@property (nonatomic, retain) BudgetThreeClass *threeClass;
@property (nonatomic, retain) UITextField *titleField;
@property (nonatomic, retain) UITextField *allMoney;
@property (nonatomic, retain) UILabel *label;

-(instancetype)initWithThreeClass:(BudgetThreeClass *)threeClass;

@end
