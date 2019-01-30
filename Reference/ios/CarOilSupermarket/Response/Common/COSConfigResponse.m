//
//  COSConfigResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/22.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSConfigResponse.h"

@implementation COSConfigMemberInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"memberId":@"id"};
}

@end

@implementation COSConfigInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"memberGroup":[COSConfigMemberInfo class]};
}

@end

@implementation COSConfigResponse

@end
