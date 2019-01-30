//
//  CourtAddResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/23.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "MatchInfo.h"

@interface CourtAddResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchInfo *data;

@end
