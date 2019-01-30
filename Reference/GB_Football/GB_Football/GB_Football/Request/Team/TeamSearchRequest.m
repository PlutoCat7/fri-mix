//
//  TeamSearchRequest.m
//  GB_Football
//
//  Created by gxd on 17/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamSearchRequest.h"
#import "TeamSearchResponseInfo.h"

@implementation TeamSearchRequest

- (Class)responseClass {
    
    return [TeamSearchResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"team_manage_controller/searchteam";
}

- (NSDictionary *)parameters {
    
    return @{@"search_name":self.searchKey};
}

@end
