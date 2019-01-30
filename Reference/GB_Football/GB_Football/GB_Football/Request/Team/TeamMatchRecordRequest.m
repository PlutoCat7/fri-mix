//
//  TeamMatchRecordRequest.m
//  GB_Football
//
//  Created by gxd on 17/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamMatchRecordRequest.h"

@implementation TeamMatchRecordRequest

- (Class)responseClass {
    
    return [TeamMatchRecordResponeInfo class];
}

- (NSString *)requestAction {
    
    return @"match_manage_controller/dogetteammatchlist";
}

- (NSDictionary *)parameters {
    
    return @{@"team_id":@(self.teamId)};
}
@end
