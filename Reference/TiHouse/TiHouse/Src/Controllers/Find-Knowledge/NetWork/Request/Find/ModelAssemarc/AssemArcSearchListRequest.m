//
//  AssemArcSearchListRequest.m
//  TiHouse
//
//  Created by wangshiwen on 2018/4/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemArcSearchListRequest.h"
#import "Login.h"

@implementation AssemArcSearchListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/searchWz";
}

- (NSDictionary *)parameters {
    
    return @{@"uid":@([Login curLoginUser].uid),
             @"searchText":_searchText?_searchText:@""
             };
}

@end
