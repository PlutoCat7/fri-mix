//
//  TeamTacticsListResponse.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TeamTacticsListResponse.h"

@implementation TeamTacticsInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"tacticsId":@"id"};
}

@end

@implementation TeamTacticsListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamTacticsInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
