//
//  CommonDataCenter.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonDataCenter.h"

@implementation CommonDataCenter

- (instancetype)init
{
    if (self = [super init])
    {
        self.hasKnowledgeAdvertisements = NO;
    }
    return self;
}

+ (instancetype)shareCommonDataCenter
{
    static CommonDataCenter *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[CommonDataCenter alloc]init];
    });
    return engine;
}

@end
