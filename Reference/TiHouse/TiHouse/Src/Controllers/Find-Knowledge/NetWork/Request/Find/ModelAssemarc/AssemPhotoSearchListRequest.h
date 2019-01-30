//
//  AssemPhotoSearchListRequest.h
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "FindAssemarcListResponse.h"
#import "Login.h"

@interface AssemPhotoSearchListRequest : BasePageNetworkRequest

@property (nonatomic, copy) NSString *searchText;

@end
