//
//  AssemPhotoMoreListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemPhotoMoreListRequest.h"
#import "Login.h"

@implementation AssemPhotoMoreListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/pageTtByAssemarcid";
}

- (NSDictionary *)parameters {
    
    return @{@"uid":@([Login curLoginUser].uid),
             @"assemarcid":@(_assemarcid)
             };
}
@end
