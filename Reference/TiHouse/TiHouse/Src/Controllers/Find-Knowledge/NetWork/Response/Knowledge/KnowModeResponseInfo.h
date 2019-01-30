//
//  KnowModeResponseInfo.h
//  TiHouse
//
//  Created by weilai on 2018/2/13.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponseInfo.h"
#import "KnowModeInfo.h"

@interface KnowModeResponseInfo : GBResponseInfo

@property (nonatomic, strong) KnowModeInfo *data;

@end
