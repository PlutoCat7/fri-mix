//
//  ScheduleOptionsViewModel.m
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleOptionsViewModel.h"

@implementation ScheduleOptionsViewModel

- (instancetype)init{
    if (self = [super init]) {
//        self.isOpenList = YES;
        _scheduletype = 0;
//        _timeType = -1;
    }
    return self;
}

- (RACSubject *)reloadData{
    if (!_reloadData) {
        _reloadData = [RACSubject subject];
    }
    return _reloadData;
}

- (NSString *)chooseTitle{
    if (!_chooseTitle) {
        _chooseTitle = @"全部日程";
    }
    return _chooseTitle;
}

- (NSArray *)arrData{
    if (!_arrData) {
        _arrData = @[@{@"title":@"全部日程",
                       @"type":@"2",
                       @"selStatus":@"-1"},
                     @{@"title":@"已完成的日程",
                       @"type":@"3",
                       @"selStatus":@"1"
                       },
                     @{@"title":@"未完成的日程",
                       @"type":@"4",
                       @"selStatus":@"0"
                       }];
//        _arrData = @[
////                      @[@{@"title":@"未来的日程",
////                          @"type":@"1",
////                          @"selStatus":@"1"
////                          },
////                        @{@"title":@"过去的日程",
////                          @"type":@"2",
////                          @"selStatus":@"0"}
////                        ],
//                      @[@{@"title":@"已完成的日程",
//                          @"type":@"3",
//                          @"selStatus":@"1"
//                          },
//                        @{@"title":@"未完成的日程",
//                          @"type":@"4",
//                          @"selStatus":@"0"
//                          }
//                        ]
//                      ];
    }
    return _arrData;
    
}


@end
