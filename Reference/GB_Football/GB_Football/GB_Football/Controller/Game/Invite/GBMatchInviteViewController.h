//
//  GBMatchInviteViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBMatchInviteViewController : GBBaseViewController

@property (nonatomic, copy) void(^joinFriendCountBlock)(NSInteger joinCount);

- (instancetype)initWithMatchId:(NSInteger)matchId gameType:(GameType)gameType;

@end
