//
//  TeamAddPlayerInfo.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PlayerResponseInfo.h"

@interface TeamAddPlayerInfo : PlayerInfo

@property (nonatomic, assign) BOOL isSelect;

@end

@interface TeamAddPlayerResponeInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamAddPlayerInfo *> *data;

@end
