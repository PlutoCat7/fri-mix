//
//  AssemArcMoreListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemArcMoreListRequest.h"
#import "Login.h"

@implementation AssemArcMoreListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/pageWz";
}

- (NSDictionary *)parameters {
    return @{@"uid":@([Login curLoginUser].uid),@"assemarcid":self.assemarcid};
}

@end
