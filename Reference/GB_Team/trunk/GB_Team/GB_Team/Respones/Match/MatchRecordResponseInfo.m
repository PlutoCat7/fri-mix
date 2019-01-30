//
//  MatchBaseResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRecordResponseInfo.h"

@implementation MatchRecordInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchId":@"match_id",
             @"matchName":@"match_name",
             @"matchTime":@"match_time",
             @"courtName":@"court_name",
             @"courtAddress":@"court_address"};
}

@end

@implementation MatchRecordResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MatchRecordInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
