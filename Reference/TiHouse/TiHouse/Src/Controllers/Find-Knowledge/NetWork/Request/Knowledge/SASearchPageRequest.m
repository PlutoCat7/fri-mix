//
//  SASearchPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SASearchPageRequest.h"

@interface SASearchPageRequest()

@property (assign, nonatomic) KnowType knowType;
@property (assign, nonatomic) KnowTypeSub knowTypeSub;

@end

@implementation SASearchPageRequest

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
        return @"/api/inter/know/search1ByType";
    } else if (_knowTypeSub == KnowTypeSub_Poster) {
        return @"/api/inter/know/searchXb";
    }
    return @"/api/inter/know/search2ByType";
}

- (NSDictionary *)parameters {
    
    if (_knowType == KnowType_None) {
        return @{@"searchKnowtitle" : self.keyword};
    } else {
        return @{@"searchKnowtitle" : self.keyword,
                 @"knowtype" : @(self.knowType)
                 };
    }
    
}

@end
