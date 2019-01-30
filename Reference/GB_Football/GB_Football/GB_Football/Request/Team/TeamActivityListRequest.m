//
//  TeamActivityListRequest.m
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamActivityListRequest.h"

@implementation TeamActivityListRequest

- (Class)responseClass {
    
    return [TeamActivityListResponeInfo class];
}

- (NSString *)requestAction {
    
    return @"activity_manage_controller/getList";
}

@end
