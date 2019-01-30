//
//  MessageTeamListResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MessageTeamListResponseInfo.h"

@implementation MessageTeamInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"messageId":@"id",
             @"messageType":@"type",
             @"messageStatus":@"status"};
}

@end

@implementation MessageTeamListResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MessageTeamInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
