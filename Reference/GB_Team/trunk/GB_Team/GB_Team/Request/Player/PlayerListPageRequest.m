//
//  PlayerListPageRequest.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PlayerListPageRequest.h"
#import "PlayerResponseInfo.h"

@implementation PlayerListPageRequest

- (Class)responseClass {
    
    return [PlayerResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"player/getlist";
}

@end
