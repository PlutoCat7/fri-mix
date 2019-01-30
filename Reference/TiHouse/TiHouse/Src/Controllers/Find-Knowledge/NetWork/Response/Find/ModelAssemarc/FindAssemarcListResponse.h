//
//  FindAssemarcListResponse.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "FindAssemarcInfo.h"

@interface FindAssemarcListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *data;

@end
