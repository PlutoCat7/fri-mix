//
//  TeammateSearchRequest.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeammateSearchRequest.h"

@implementation TeammateSearchRequest

- (Class)responseClass {
    
    return [TeamNewTeammateSearchResponsePageInfo class];
}

- (NSString *)requestAction {
    
    return @"team_manage_controller/getsearchnameorphonelist";
}

- (NSDictionary *)parameters {
    
    return @{@"search_key":self.searchPhone};
}

@end
