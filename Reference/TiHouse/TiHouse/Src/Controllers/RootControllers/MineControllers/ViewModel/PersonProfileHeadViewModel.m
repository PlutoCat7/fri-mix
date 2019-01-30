//
//  PersonProfileHeadViewModel.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PersonProfileHeadViewModel.h"

@implementation PersonProfileHeadViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.headViewBackgroundColor = RGB(253, 240, 134);
        self.placeHolderImage = [UIImage imageNamed:@"placeHolder"];
    }
    return self;
}

@end
