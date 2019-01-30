//
//  MorelLineLabelWithBackgroundViewModel.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MorelLineLabelWithBackgroundViewModel.h"

@implementation MorelLineLabelWithBackgroundViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.leftSpace = 26;
        self.rightSpace = 26;
        self.backgoundViewLeftRightSpace = 10;
        self.cellBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
