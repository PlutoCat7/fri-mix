//
//  GBPersonPositionSetting.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/8/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPersonPositionSetting : GBBaseViewController

@property (nonatomic,copy) void(^saveBlock)(NSArray<NSString *>* selectIndexList);

- (instancetype)initWithSelectList:(NSArray<NSString *> *)selectList;

@end
