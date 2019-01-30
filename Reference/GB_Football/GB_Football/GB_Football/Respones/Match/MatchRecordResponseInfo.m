//
//  MatchRecordResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRecordResponseInfo.h"


@implementation MatchRecordResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MatchInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
