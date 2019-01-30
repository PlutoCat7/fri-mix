//
//  PosterPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterPageRequest.h"

@implementation PosterPageRequest

- (Class)responseClass {
    
    return [PosterListPesponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/group/page";
}

@end
