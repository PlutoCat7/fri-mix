//
//  ApkUpdateResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "ApkUpdateResponseInfo.h"

@implementation ApkUpdateInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"apkUrl":@"url",
             @"isForce":@"is_force"};
}

@end

@implementation ApkUpdateResponseInfo

@end
