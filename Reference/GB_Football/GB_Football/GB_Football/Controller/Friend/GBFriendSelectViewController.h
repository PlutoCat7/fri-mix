//
//  GBFriendSelectViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@class FriendInfo;
@interface GBFriendSelectViewController : GBBaseViewController

- (instancetype)initWithSelectedFriendList:(NSArray<FriendInfo *> *)friendList;

@end
