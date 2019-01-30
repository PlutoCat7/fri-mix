//
//  RemindListView.h
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "ScheduleModel.h"

@interface RemindListView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id <BaseViewModelProtocol>)viewModel;

@property (copy, nonatomic) void (^SelectRemindBlock)(NSString *value, NSInteger index);
@property (assign, nonatomic) long scheduletiptype;

@end
