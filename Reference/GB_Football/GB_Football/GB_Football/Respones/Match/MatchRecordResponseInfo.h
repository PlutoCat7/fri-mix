//
//  MatchRecordResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "MatchInfo.h"


@interface MatchRecordResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<MatchInfo *> *data;

@end
