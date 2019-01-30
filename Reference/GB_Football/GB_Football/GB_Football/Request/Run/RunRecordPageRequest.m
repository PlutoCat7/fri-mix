//
//  RunRecordPageRequest.m
//  GB_Football
//
//  Created by gxd on 17/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunRecordPageRequest.h"
#import "RunRecordResponseInfo.h"

@implementation RunRecordPageRequest

- (Class)responseClass {
    
    return [RunRecordResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"user_run_manage_controller/getrunlist";
}

@end
