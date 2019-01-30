//
//  AssemHotArcListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemHotArcListRequest.h"

@implementation AssemHotArcListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/pageTt";
}

- (NSDictionary *)parameters {
    
    return @{@"sorttype":@(_type),
             @"assemid":@(_assemId)
             };
}

@end
