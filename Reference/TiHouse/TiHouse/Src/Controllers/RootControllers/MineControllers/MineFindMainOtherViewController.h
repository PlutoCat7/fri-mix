//
//  MineFindMainOtherViewController.h
//  TiHouse
//
//  Created by admin on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class User;
@interface MineFindMainOtherViewController : BaseViewController

@property (nonatomic, assign) long uid;
@property (nonatomic, strong) User *other;
@property (nonatomic, copy) void(^reloadBlock)(void);

@end
