//
//  AllSearchPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AllSearchPageRequest.h"

@implementation AllSearchPageRequest

- (Class)responseClass {
    
    return [SAListResponse class];
}

- (NSString *)requestAction {
    
    return @"/api/inter/know/searchall";
}

- (NSDictionary *)parameters {
    
    return @{@"searchKnowtitle" : self.keyword};
    
}

@end
