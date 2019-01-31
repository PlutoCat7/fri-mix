//
//  CourtResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CourtResponseInfo.h"

@implementation CourtInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"courtId":@"id",
             @"location":@"court_location",
             @"locA":@"court_a",
             @"locB":@"court_b",
             @"locC":@"court_c",
             @"locD":@"court_d",
             @"courtName":@"court_name",
             @"courtNameFL":@"court_name_fl",
             @"courtAddress":@"court_address"};
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