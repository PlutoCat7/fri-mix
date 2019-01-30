//
//  MessageTeamPageRequest.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MessageTeamPageRequest.h"

@implementation MessageTeamPageRequest

- (Class)responseClass {
    
    return [MessageTeamListResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"team_manage_controller/teammessagelist";
}

@end
