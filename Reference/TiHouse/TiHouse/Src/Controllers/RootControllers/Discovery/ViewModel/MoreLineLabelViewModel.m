//
//  MoreLineLabelViewModel.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "MoreLineLabelViewModel.h"

@implementation MoreLineLabelViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.font = 12;
        self.leftSpace = 50;
        self.rightSpace = 50;
        self.textColor = RGB(51, 51, 51);
        self.textAlignment = NSTextAlignmentCenter;
        self.canCopy = NO;
        self.lineNumber = 0;
    }
    return self;
}

@end
