//
//  AssemHotArcListRequest.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "FindAssemarcListResponse.h"

@interface AssemHotArcListRequest : BasePageNetworkRequest

@property (nonatomic, assign) long assemId;
@property (nonatomic, assign) NSInteger type;  //1:hot 2:newest

@end
