//
//  FindAssemActivityInfo.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemActivityInfo.h"

@implementation FindAssemUserInfo

@end

@implementation FindAssemActivityInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"userJA":@"FindAssemUserInfo"};
}

- (NSString *)titleWithPreSub {
    
    return [NSString stringWithFormat:@"#%@#", self.assemtitle];
}

@end
