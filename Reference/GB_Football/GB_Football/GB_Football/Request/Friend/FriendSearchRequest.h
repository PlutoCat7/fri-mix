//
//  FriendSearchRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "FriendSearchResponseInfo.h"

@interface FriendSearchRequest : BasePageNetworkRequest

@property (nonatomic, copy) NSString *searchPhone;

@end
