//
//  NewScheduleVC.h
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "ScheduleModel.h"

typedef void(^RefreshListBlock)(void);
@interface NewScheduleVC : BaseViewController

@property (strong, nonatomic) House * house;

@property (strong, nonatomic) ScheduleModel * scheduleM;
///创建时间
@property (copy, nonatomic) NSDate * createDate;
//回调刷新block
@property (copy, nonatomic) RefreshListBlock refreshBlock;

@end
