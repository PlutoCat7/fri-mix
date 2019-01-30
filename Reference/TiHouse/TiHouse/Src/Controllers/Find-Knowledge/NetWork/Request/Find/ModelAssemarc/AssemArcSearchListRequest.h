//
//  AssemArcSearchListRequest.h
//  TiHouse
//
//  Created by wangshiwen on 2018/4/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "FindAssemarcListResponse.h"

@interface AssemArcSearchListRequest : BasePageNetworkRequest

@property (nonatomic, copy) NSString *searchText;

@end
