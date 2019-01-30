//
//  GBTacticsPlayerModel.m
//  TestDemo
//
//  Created by yahua on 2017/12/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "GBTacticsPlayerModel.h"

@implementation GBTacticsPlayerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playerNumber = @"";
        self.playerName = @"";
        self.playerColor = [UIColor redColor];
    }
    return self;
}

@end
