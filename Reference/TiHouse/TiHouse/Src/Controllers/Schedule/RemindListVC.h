//
//  RemindListVC.h
//  TiHouse
//  提醒列表界面
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RemindListSelectBlock)(NSString *value, NSInteger index);
@interface RemindListVC : BaseViewController

@property (assign, nonatomic) long scheduletiptype;
@property (copy, nonatomic) RemindListSelectBlock remindListSelectBlock;

@end
