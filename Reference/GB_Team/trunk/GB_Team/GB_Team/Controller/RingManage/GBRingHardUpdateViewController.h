//
//  GBRingHardUpdateViewController.h
//  GB_Team
//
//  Created by Pizza on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "BindWristbandListResponeInfo.h"

@interface GBRingHardUpdateViewController : GBBaseViewController

- (instancetype)initWithWristList:(NSArray<WristbandInfo *> *)wristList;

@end
