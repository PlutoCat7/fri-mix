//
//  HomeViewControllerViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeViewControllerViewModel.h"
#import "HomeRequest.h"

@interface HomeViewControllerViewModel ()
@end

@implementation HomeViewControllerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
        [self addObserver];
    }
    return self;
}

- (void)getNetworkDataWithHandler:(void(^)(NSError *error))handler {
    
    [HomeRequest getHomeDataWithUserId:[RawCacheManager sharedRawCacheManager].userId handler:^(id result, NSError *error) {
       
        if (!error) {
            
            self.homeData = result;
            //缓存
            [self.homeData saveCache];
        }
        BLOCK_EXEC(handler, error);
    }];
}

#pragma mark - Notification

- (void)notificationUserInfoChange {
    
    //先刷新界面
    [self willChangeValueForKey:@"showGoodsList"];
    [self didChangeValueForKey:@"showGoodsList"];
    //刷新列表
    [self getNetworkDataWithHandler:nil];
}

#pragma mark - Private

- (void)loadData {
    
    self.homeData = [HomeNetworkData loadCache];
}

- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserInfoChange) name:Notification_Has_Login_In object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserInfoChange) name:Notification_Has_Login_Out object:nil];
}

#pragma mark - Setter and Getter  

- (void)setHomeData:(HomeNetworkData *)homeData {
    
    _homeData = homeData;
    NSMutableArray *showGoodsList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i=0; i<homeData.goodsList.count;) {
        NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
        [tmpList addObject:homeData.goodsList[i]];
        i++;
        if (i<homeData.goodsList.count) {
            [tmpList addObject:homeData.goodsList[i]];
            i++;
        }
        [showGoodsList addObject:[tmpList copy]];
    }
    self.showGoodsList = [showGoodsList copy];
}

@end
