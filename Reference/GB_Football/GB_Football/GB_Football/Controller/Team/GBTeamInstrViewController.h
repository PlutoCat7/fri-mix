//
//  GBTeamInstrViewController.h
//  GB_Football
//
//  Created by gxd on 17/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBTeamInstrViewController : GBBaseViewController

@property (nonatomic, assign) NSInteger minLenght;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic,copy) void(^saveBlock)(NSString* name);

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@end
