//
//  SwitchOptionsViewModel.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/2.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "SwitchOptionsViewModel.h"

@implementation SwitchOptionsViewModel

- (void)setIsChoosed:(BOOL)isChoosed
{
    if (isChoosed)
    {
        _titleColor = RGB(254, 192, 12);
    }
    else
    {
        _titleColor = RGB(56, 56, 56);
    }
    _isChoosed = isChoosed;
}

@end
