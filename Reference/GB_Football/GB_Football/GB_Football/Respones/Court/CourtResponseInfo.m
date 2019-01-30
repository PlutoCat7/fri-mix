//
//  CourtResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CourtResponseInfo.h"

@implementation CourtInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"courtId":@"id",
             @"courtName":@"court_name",
             @"courtNameFL":@"court_name_fl",
             @"courtAddress":@"court_address",
             @"location":@"court_location",
             @"locA":@"court_a",
             @"locB":@"court_b",
             @"locC":@"court_c",
             @"locD":@"court_d",
             @"courtType":@"type"};
}

@end

@implementation CourtResponseData

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"items":@"CourtInfo"};
}

- (void)setName:(NSString *)name {
    
    _name = [name uppercaseString];
}

@end

@implementation CourtResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"CourtResponseData"};
}

@end
