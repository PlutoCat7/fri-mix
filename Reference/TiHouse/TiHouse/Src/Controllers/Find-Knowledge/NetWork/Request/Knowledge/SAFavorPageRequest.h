//
//  SAFavorPageRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "SAListResponse.h"
#import "Enums.h"

@interface SAFavorPageRequest : BasePageNetworkRequest

- (instancetype)initWithKnowTypeSub:(KnowTypeSub)knowTypeSub;

@end
