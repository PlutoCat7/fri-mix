//
//  AssemPhotoSearchListRequest.m
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemPhotoSearchListRequest.h"

@implementation AssemPhotoSearchListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/searchTt";
}

- (NSDictionary *)parameters {
    
    return @{@"uid":@([Login curLoginUser].uid),
             @"searchText":_searchText?_searchText:@""
             };
}

@end
