//
//  SAPageRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "SAListResponse.h"
#import "Enums.h"

@interface SAPageRequest : BasePageNetworkRequest

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub;

@end
