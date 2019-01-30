//
//  TeamNewTeammateResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamNewTeammateResponseInfo.h"

@implementation TeamNewTeammateInfo

- (TeamNewTeammateState)state {
    
    if (![NSString stringIsNullOrEmpty:self.team_name]) {
        return TeamNewTeammateState_Joined;
    }
    return _state;
}

@end

@implementation TeamNewTeammateResponse

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"friend_List":@"friend_no_team"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"apply_list":@"TeamNewTeammateInfo",
             @"friend_List":@"TeamNewTeammateInfo"};
}

- (void)setFriend_List:(NSArray<TeamNewTeammateInfo *> *)friend_List {
    
    _friend_List = friend_List;
    for(TeamNewTeammateInfo *info in friend_List) {
        
        info.state = TeamNewTeammateState_Normal;
    }
}

- (void)setApply_list:(NSArray<TeamNewTeammateInfo *> *)apply_list {
    
    _apply_list = apply_list;
    for(TeamNewTeammateInfo *info in apply_list) {
        
        info.state = TeamNewTeammateState_Invited;
    }
}

@end

@implementation TeamNewTeammateResponseInfo

@end
