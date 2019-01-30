//
//  RCDRCIMDataSource.m
//  TiHouse
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "RCDRCIMDataSource.h"
#import "Login.h"

@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource *)shareInstance {
    static RCDRCIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    User *user = [Login curLoginUser];
//    if (userId == user.uid) {
    RCUserInfo *userInfo = [[RCUserInfo alloc]init];
    userInfo.userId = [NSString stringWithFormat:@"%ld", user.uid];
    userInfo.name = user.username;
    userInfo.portraitUri = user.urlhead;
    return completion(userInfo);
//    }
}

@end

