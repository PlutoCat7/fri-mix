//
//  FriendSearchResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "FriendListResponseInfo.h"

@interface FriendSearchResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<FriendInfo *> *data;

@end
