//
//  MatchCreateResponseInfo.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/24.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface MatchCreateInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger matchId;

@end

@interface MatchCreateResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchCreateInfo *data;

@end
