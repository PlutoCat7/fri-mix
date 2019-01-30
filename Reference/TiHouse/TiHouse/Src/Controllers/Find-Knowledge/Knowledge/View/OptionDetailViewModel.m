//
//  OptionDetailViewModel.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OptionDetailViewModel.h"

@implementation OptionDetailViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.rightOptionText = @"0";
        self.arrowImage = [UIImage imageNamed:@"icon_content_right_go"];
    }
    return self;
}

@end
