//
//  ScheduleDetailViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface ScheduleDetailViewModel : BaseViewModel

@property (nonatomic, strong) UIColor  *leftIconBackgroundColor;
@property (nonatomic, copy  ) NSString *leftIconTitle;
@property (nonatomic, copy  ) NSString *optionText;
@property (nonatomic, assign) BOOL     canSwipe;//能否左滑

@end
