//
//  screenPopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BudgetThreeClass;
@interface AddBudgetPopView : UIView

@property (nonatomic ,copy) void(^finishSelectde)(BudgetThreeClass *threeClass, BOOL isNew);
@property (nonatomic, retain) BudgetThreeClass *threeClass;

-(instancetype)initWithBudgetThreeClass:(BudgetThreeClass *)threeClass;
-(void)Show;

@end
