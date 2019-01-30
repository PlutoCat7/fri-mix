//
//  FindAssemarcAttentionListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemarcAttentionListRequest.h"

@implementation FindAssemarcAttentionListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/pageMyConcern";
}

@end
