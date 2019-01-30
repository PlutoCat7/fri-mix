//
//  Houses.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Logbudgetopes.h"
#import "Logbudgetope.h"
#import "NSDate+Extend.h"
@implementation Logbudgetopes


- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = @0;
        _pageSize = @20;
        _list = [NSMutableArray array];
    }
    return self;
}



- (NSString *)toPath{
    NSString *requstPath = @"api/inter/logbudgetproope/pageByBudgetid";
    return requstPath;
}


-(NSDictionary *)toParams{
    
    return  @{@"start":_page,@"limit":_pageSize,@"budgetid":@(_budget.budgetid)};
}

- (void)configWithLogbudgetopes:(NSArray *)responseA{
    if (responseA && [responseA count] > 0) {
        self.canLoadMore = YES;
        if (_willLoadMore) {
//            数据结构转换
            [responseA enumerateObjectsUsingBlock:^(Logbudgetope *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (_list.count == 0) {
                    NSMutableArray *arr = [NSMutableArray new];
                    [arr addObject:obj];
                    [_list addObject:arr];
                }else{
                    NSMutableArray *listLastArr = _list.lastObject;
                    Logbudgetope *logbudgetope = listLastArr.lastObject;
                    NSDate *logbudgetopeData = [NSDate dateWithTimeIntervalSince1970:logbudgetope.budgetopetime/1000];
                    NSDate *objData = [NSDate dateWithTimeIntervalSince1970:obj.budgetopetime/1000];
                    if ([[logbudgetopeData ymdFormat] isEqualToString:[objData ymdFormat] ]) {
                        [listLastArr addObject:obj];
                    }else{
                        NSMutableArray *arr = [NSMutableArray new];
                        [arr addObject:obj];
                        [_list addObject:arr];
                    }
                }
            }];
//            [_list addObjectsFromArray:responseA];
        }else{
            [self.list removeAllObjects];
            [responseA enumerateObjectsUsingBlock:^(Logbudgetope *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (_list.count == 0) {
                    NSMutableArray *arr = [NSMutableArray new];
                    [arr addObject:obj];
                    [_list addObject:arr];
                }else{
                    NSMutableArray *listLastArr = _list.lastObject;
                    Logbudgetope *logbudgetope = listLastArr.lastObject;
                    NSDate *logbudgetopeData = [NSDate dateWithTimeIntervalSince1970:logbudgetope.budgetopetime/1000];
                    NSDate *objData = [NSDate dateWithTimeIntervalSince1970:obj.budgetopetime/1000];
                    if ([[logbudgetopeData ymdFormat] isEqualToString:[objData ymdFormat] ]) {
                        
                        [listLastArr addObject:obj];
                    }else{
                        NSMutableArray *arr = [NSMutableArray new];
                        [arr addObject:obj];
                        [_list addObject:arr];
                    }
                }
            }];

        }
    }else{
        self.canLoadMore = NO;
        if (!_willLoadMore) {
//            self.list = [NSMutableArray array];
        }
    }
}


@end
