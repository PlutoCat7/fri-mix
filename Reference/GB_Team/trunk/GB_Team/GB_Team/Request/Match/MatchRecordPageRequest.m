//
//  MatchRecordPageRequest.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRecordPageRequest.h"

@implementation MatchRecordPageRequest

- (Class)responseClass {
    
    return [MatchRecordResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"match/getlist";
}

@end
