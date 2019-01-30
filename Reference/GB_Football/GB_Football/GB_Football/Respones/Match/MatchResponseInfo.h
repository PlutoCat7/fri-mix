//
//  MatchResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "MatchInfo.h"

@interface MatchResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchInfo *data;

@end
