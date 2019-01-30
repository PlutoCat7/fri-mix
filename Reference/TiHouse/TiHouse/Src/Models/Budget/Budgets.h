//
//  Budgets.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Budget.h"
@class House;
@interface Budgets : NSObject

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (readwrite, nonatomic, strong) House *house;
@property (readwrite, nonatomic, strong) NSMutableArray *list;
@property (readwrite, nonatomic, strong) NSNumber *page, *pageSize;

- (NSString *)toPath;
- (NSDictionary *)toParams;

@end
