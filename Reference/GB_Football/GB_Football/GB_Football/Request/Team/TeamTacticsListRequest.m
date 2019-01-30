//
//  TeamTacticsListRequest.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TeamTacticsListRequest.h"

@implementation TeamTacticsListRequest

- (Class)responseClass {
    
    return [TeamTacticsListResponse class];
}

- (NSString *)requestAction {
    
    return @"tactics_manage_controller/dolist";
}

@end
