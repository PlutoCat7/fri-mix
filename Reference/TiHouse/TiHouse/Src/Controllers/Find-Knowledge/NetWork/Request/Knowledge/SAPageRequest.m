//
//  SAPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SAPageRequest.h"

@interface SAPageRequest()

@property (assign, nonatomic) KnowType knowType;
@property (assign, nonatomic) KnowTypeSub knowTypeSub;

@end

@implementation SAPageRequest

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub {
    self = [super init];
    if (self) {
        _knowType = knowType;
        _knowTypeSub = knowTypeSub;
    }
    return self;
}

- (Class)responseClass {
    
    return [SAListResponse class];
}

- (NSString *)requestAction {
    
    if (_knowTypeSub == KnowTypeSub_Size) {
        return @"/api/inter/know/page1ByType";
    }
    return @"/api/inter/know/page2ByType";
}

- (NSDictionary *)parameters {
    
    return @{@"knowtype" : @(_knowType)};
}

@end
