//
//  TeamNewTeammateSearchResponsePageInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamNewTeammateSearchResponsePageInfo.h"

@implementation TeamNewTeammateSearchResponsePageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamNewTeammateInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}


@end
