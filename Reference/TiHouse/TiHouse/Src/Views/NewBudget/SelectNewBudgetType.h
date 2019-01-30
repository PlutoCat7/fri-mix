//
//  SelectNewBudgetType.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectNewBudgetType;
@protocol SelectNewBudgetTypeDelegate<NSObject>

-(void)SelectNewBudgetTypeBtntag:(NSInteger)tag;

@end

@interface SelectNewBudgetType : UIView

@property (nonatomic, weak) id<SelectNewBudgetTypeDelegate> delegate;
-(void)Show;

@end
