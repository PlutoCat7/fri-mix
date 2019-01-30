//
//  AddressListResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "AddressListResponse.h"

@implementation AddressInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"addressId":@"id"};
}

@end

@implementation AddressListInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"AddressInfo"};
}

@end

@implementation AddressListResponse

@end
