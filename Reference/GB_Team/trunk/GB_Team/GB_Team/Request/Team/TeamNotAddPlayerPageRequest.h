//
//  TeamNotAddPlayerPageRequest.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "TeamAddPlayerResponeInfo.h"

@interface TeamNotAddPlayerPageRequest : BasePageNetworkRequest

@property (nonatomic, assign) NSInteger teamId;

@end
