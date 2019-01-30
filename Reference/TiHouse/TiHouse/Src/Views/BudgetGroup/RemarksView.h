//
//  RemarksView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager.h>
@class BudgetThreeClass;
@interface RemarksView : UIView

@property (nonatomic, retain) BudgetThreeClass *threeClass;
//@property (nonatomic, retain) UITextView *TextView;
//@property (nonatomic, retain) UITextField *TextView;
//@property (nonatomic, retain) UITextView *TextView;
@property (nonatomic, strong) IQTextView *TextView;

@end
