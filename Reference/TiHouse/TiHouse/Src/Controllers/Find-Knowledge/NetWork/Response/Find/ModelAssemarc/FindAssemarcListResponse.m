//
//  FindAssemarcListResponse.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemarcListResponse.h"
#import "Login.h"

@implementation FindAssemarcListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindAssemarcInfo class]};
}

- (NSArray *)onePageData {
    
    return self.data;
}

- (NSString *)getCacheKey {
    
    NSString *superKey = [super getCacheKey];
    return superKey;
}

@end
