//
//  TeamNewTeammateSearchResponsePageInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "TeamNewTeammateResponseInfo.h"

@interface TeamNewTeammateSearchResponsePageInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *data;

@end
