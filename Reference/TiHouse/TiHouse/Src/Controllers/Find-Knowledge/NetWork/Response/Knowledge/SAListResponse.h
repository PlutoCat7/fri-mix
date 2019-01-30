//
//  SAListResponse.h
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "KnowModeInfo.h"

@interface SAListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<KnowModeInfo *> *data;

@end
