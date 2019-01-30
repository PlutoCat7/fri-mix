//
//  HouseInfoViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/19.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "House.h"

@interface HouseInfoViewController : BaseViewController

@property (nonatomic, retain) House *house;

@property (assign, nonatomic) BOOL isFixNavigation;

@end
