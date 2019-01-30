//
//  FindAssemActivityResponse.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponseInfo.h"
#import "FindAssemActivityInfo.h"

@interface FindAssemActivityResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<FindAssemActivityInfo *> *data;

@end

@interface FindAssemActivityDetailResponse : GBResponseInfo

@property (nonatomic, strong) FindAssemActivityInfo *data;

@end
