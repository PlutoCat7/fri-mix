//
//  AssemarcFavorListRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemarcFavorListRequest.h"

@implementation AssemarcFavorListRequest

- (Class)responseClass {
    
    return [FindAssemarcListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/assemarc/pageMycoll";
}

@end
