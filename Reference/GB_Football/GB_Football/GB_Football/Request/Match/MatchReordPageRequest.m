//
//  MatchReordPageRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchReordPageRequest.h"

#import "MatchRecordResponseInfo.h"

@implementation MatchReordPageRequest

- (Class)responseClass {
    
    return [MatchRecordResponseInfo class];
}

- (NSDictionary *)parameters {
    
    if (_gameType<0) {
        return @{};
    }else {
        return @{@"type":@(_gameType)};
    }
}

- (NSString *)requestAction {
    
    return @"user_match_list_controller/domatchlist";
}

@end
