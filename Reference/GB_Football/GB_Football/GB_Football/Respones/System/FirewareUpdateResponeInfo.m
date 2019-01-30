//
//  FirewareUpdateResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "FirewareUpdateResponeInfo.h"

@implementation FirewareUpdateInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"firewareUrl":@"url",
             @"isForce":@"is_force"};
}

@end

@implementation FirewareUpdateResponeInfo

@end
