//
//  ColorFavorPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorFavorPageRequest.h"

@implementation ColorFavorPageRequest

- (Class)responseClass {
    
    return [ColorCardListResponse class];
}

- (NSString *)requestAction {
    
    return @"/api/inter/colorcard/pageColl";
}

@end
