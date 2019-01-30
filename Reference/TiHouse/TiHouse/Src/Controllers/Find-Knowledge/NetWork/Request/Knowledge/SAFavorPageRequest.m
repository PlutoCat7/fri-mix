//
//  SAFavorPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SAFavorPageRequest.h"


@interface SAFavorPageRequest()

@property (assign, nonatomic) KnowTypeSub knowTypeSub;

@end

@implementation SAFavorPageRequest

- (instancetype)initWithKnowTypeSub:(KnowTypeSub)knowTypeSub {
    self = [super init];
    if (self) {
        _knowTypeSub = knowTypeSub;
    }
    return self;
}

- (Class)responseClass {
    
    return [SAListResponse class];
}

- (NSString *)requestAction {
    
    if (_knowTypeSub == KnowTypeSub_Size) {
        return @"/api/inter/know/pageColl1";
    }
    return @"/api/inter/know/pageColl2";
}

@end
