//
//  AssemPhotoMoreListRequest.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "FindAssemarcListResponse.h"

@interface AssemPhotoMoreListRequest : BasePageNetworkRequest

@property (nonatomic, assign) long assemarcid;   //套图id

@end
