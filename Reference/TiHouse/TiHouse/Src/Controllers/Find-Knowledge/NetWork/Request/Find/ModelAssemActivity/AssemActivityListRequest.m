//
//  AssemActivityListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemActivityListRequest.h"

@implementation AssemActivityListRequest

- (Class)responseClass {
    
    return [AssemListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assem/page";
}


@end
