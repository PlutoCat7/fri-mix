//
//  MatchDoingFriendResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "FriendListResponseInfo.h"

@interface MatchDoingFriendResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<FriendInfo *> *data;

@end
