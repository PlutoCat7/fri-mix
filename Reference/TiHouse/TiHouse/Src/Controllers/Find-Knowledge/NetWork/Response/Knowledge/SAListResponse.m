//
//  SAListResponse.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SAListResponse.h"

@implementation SAListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[KnowModeInfo class]};
}


- (NSArray *)onePageData {
    
    return self.data;
}

@end
