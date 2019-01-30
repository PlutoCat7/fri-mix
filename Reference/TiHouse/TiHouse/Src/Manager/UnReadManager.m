//
//  UnReadManager.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-23.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "UnReadManager.h"

@implementation UnReadManager
+ (instancetype)shareManager{
    static UnReadManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)updateUnRead{

    [[TiHouse_NetAPIManager sharedManager] request_UnReadNotificationsWithBlock:^(id data, NSError *error) {
        NSDictionary *dataDict = (NSDictionary *)data;
        self.me_update_count = [dataDict objectForKey:kUnReadKey_notification_Me];
        self.find_update_count = [dataDict objectForKey:kUnReadKey_notification_Find];
        self.know_update_count = [dataDict objectForKey:kUnReadKey_notification_know];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadKey_mineProfileShouldReload object:nil];
    }];
    //更新应用角标
//    NSInteger unreadCount = self.messages.integerValue
//    +self.notifications.integerValue;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
}

-(void)getMeunreadCount{
    [[TiHouse_NetAPIManager sharedManager] request_UnReadNotificationsWithBlock:^(id data, NSError *error) {
        NSDictionary *dataDict = (NSDictionary *)data;
        self.me_update_count = [dataDict objectForKey:kUnReadKey_notification_Me];
        self.find_update_count = [dataDict objectForKey:kUnReadKey_notification_Find];
    }];
}


@end
