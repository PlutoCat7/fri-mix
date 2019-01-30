//
//  FindAssemarcListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemarcListRequest.h"

@implementation FindAssemarcListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/page";
}

@end
