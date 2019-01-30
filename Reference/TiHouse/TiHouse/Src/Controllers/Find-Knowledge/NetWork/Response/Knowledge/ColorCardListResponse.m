//
//  ColorCardListResponse.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorCardListResponse.h"

@implementation ColorModeInfo

@end

@implementation ColorCardListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[ColorModeInfo class]};
}


- (NSArray *)onePageData {
    
    return self.data;
}

@end
