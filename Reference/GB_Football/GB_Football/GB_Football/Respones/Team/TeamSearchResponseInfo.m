//
//  TeamSearchResponseInfo.m
//  GB_Football
//
//  Created by gxd on 17/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamSearchResponseInfo.h"

@implementation TeamSearchResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
