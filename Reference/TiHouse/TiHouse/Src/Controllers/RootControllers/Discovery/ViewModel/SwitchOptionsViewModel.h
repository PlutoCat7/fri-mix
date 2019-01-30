//
//  SwitchOptionsViewModel.h
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/2.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "BaseViewModel.h"

@interface SwitchOptionsViewModel : BaseViewModel

@property (nonatomic, copy    ) NSString *title;
@property (nonatomic, assign  ) BOOL     isChoosed;
@property (nonatomic, readonly) UIColor  *titleColor;

@end
