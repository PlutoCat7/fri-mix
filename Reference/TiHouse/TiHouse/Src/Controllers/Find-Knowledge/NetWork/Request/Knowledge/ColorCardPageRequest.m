//
//  ColorCardPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorCardPageRequest.h"

@implementation ColorCardPageRequest

- (Class)responseClass {
    
    return [ColorCardListResponse class];
}

- (NSString *)requestAction {
    
    return @"/api/inter/colorcard/page";
}

@end
