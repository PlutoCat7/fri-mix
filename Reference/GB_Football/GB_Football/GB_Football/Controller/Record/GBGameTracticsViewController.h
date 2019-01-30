//
//  GBGameTracticsViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//  战术

#import "PageViewController.h"

@interface GBGameTracticsViewController : PageViewController

- (instancetype)initWithTracticsType:(TracticsType)type players:(NSArray<TeamLineUpInfo *> *)players;

@end
