//
//  AssemListResponse.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemListResponse.h"

@implementation AssemListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindAssemActivityInfo class]};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
