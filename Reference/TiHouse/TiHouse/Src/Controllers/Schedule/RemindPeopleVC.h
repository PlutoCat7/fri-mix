//
//  RemindPeopleVC.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface RemindPeopleVC : BaseViewController

@property (strong, nonatomic) House * house;
@property (strong, nonatomic) NSString * schedulearruidtip;
@property (copy, nonatomic) void (^RemindPeopleBlock)(NSArray * array);

@end
