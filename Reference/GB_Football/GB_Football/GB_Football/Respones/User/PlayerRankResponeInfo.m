//
//  PlayerRankResponeInfo.m
//  GB_Football
//
//  Created by gxd on 2017/11/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PlayerRankResponeInfo.h"

@implementation PlayerRankInfo
    
+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"user_id",
             @"nickName":@"nick_name",
             @"photoImageUrl":@"image_url"};
}

@end

@implementation PlayerRankHeadInfo
    
@end

@implementation PlayerRankRespone
    
+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"content":@"PlayerRankInfo"};
}
    
@end

@implementation PlayerRankResponeInfo

@end
