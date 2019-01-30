//
//  AuthorViewModel.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AuthorViewModel.h"

@implementation AuthorViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.advButtonTitle = @"广告";
        self.advButtonArrowImage = [UIImage imageNamed:@"pullDown"];
        self.type = AUTHORVIEWMODELTYPE_ADVERTISEMENTSTYPE;
        self.rightButtonImage = [UIImage imageNamed:@"other_copy"];
    }
    return self;
}

@end
