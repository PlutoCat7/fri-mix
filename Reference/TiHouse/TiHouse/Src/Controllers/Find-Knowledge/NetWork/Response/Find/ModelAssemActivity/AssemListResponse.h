//
//  AssemListResponse.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "FindAssemActivityInfo.h"

@interface AssemListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<FindAssemActivityInfo *> *data;

@end
