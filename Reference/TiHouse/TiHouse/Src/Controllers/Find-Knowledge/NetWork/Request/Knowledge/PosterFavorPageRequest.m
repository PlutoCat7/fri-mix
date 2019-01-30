//
//  PosterFavorPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterFavorPageRequest.h"

@implementation PosterFavorPageRequest

- (Class)responseClass {
    
    return [KnowModeInfo class];
}

- (NSString *)requestAction {
    
    return @"api/inter/know/pageColl";
}

@end
