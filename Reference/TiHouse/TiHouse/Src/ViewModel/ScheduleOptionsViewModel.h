//
//  ScheduleOptionsViewModel.h
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM(NSUInteger, ScheduleOptionsType) {
    ScheduleOptionsTypeFuture=1,
    ScheduleOptionsTypePast=2,
    ScheduleOptionsTypeComplete=3,
    ScheduleOptionsTypeExeing=4,
};

@interface ScheduleOptionsViewModel : BaseViewModel

@property (nonatomic, strong) RACSubject *reloadData;

@property (assign, nonatomic) BOOL firstLoad;
///是否打开列表
@property (nonatomic, assign) BOOL isOpenList;
///选择的过去，未来的标题
@property (nonatomic, copy) NSString *chooseTitle;
///时间状态 1=过去 2=未来
@property (nonatomic, assign) NSInteger timeType;
///完成状态，0未完成1已完成-1全部
@property (nonatomic, assign) NSInteger scheduletype;
///数据
@property (nonatomic, strong) NSArray *arrData;


@end
