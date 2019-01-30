//
//  TeamNotAddPlayerPageRequest.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TeamNotAddPlayerPageRequest.h"

@implementation TeamNotAddPlayerPageRequest

- (Class)responseClass {
    
    return [TeamAddPlayerResponeInfo class];
}

- (NSString *)requestAction {
    
    return @"team_player/getotherlist";
}

- (NSDictionary *)parameters {
    
    return @{@"team_id":@(self.teamId)};
}

@end
