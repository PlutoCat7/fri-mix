//
//  TimerTweets.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
#import "TimerShaft.h"
#import "Dairy.h"
#import "HouseTweet.h"
@interface TimerTweets : NSObject

@property (nonatomic, retain) House *house;

@property (assign, nonatomic) BOOL currentMonthCanLoadMore, currentMonthwillLoadMore, currentMonthisLoading;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

@property (readwrite, nonatomic, strong) NSNumber *currentPage, *currentPageSize;
@property (readwrite, nonatomic, strong) NSNumber *monthpage, *monthpageSize;
@property (readwrite, nonatomic, strong) NSMutableArray *currentMonthlist;
@property (readwrite, nonatomic, strong) NSMutableArray *monthlist;
@property (nonatomic ,retain) NSArray *ALLlist;
@property (readwrite, nonatomic, strong) NSNumber *currentLastTime; // 取代原来的currentPage

@property (nonatomic, assign) BOOL isSearchResult;
@property (nonatomic, copy) NSString *searchText;

//当月
- (NSString *)toPathWithCurrentMonth;
- (NSDictionary *)toParamsWithCurrentMonth;
//月份统计
- (NSString *)toPath;
- (NSDictionary *)toParams;

- (void)configWithCurrentMonth:(NSArray *)responseA;
- (void)configWithMonthlist:(id)responseB;


-(NSInteger)addTweet:(HouseTweet *)tweet;

@end

