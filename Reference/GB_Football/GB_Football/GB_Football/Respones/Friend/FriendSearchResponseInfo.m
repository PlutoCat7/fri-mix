//
//  FriendSearchResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "FriendSearchResponseInfo.h"

@implementation FriendSearchResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"FriendInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
