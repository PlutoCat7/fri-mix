//
//  NewMessageTipsView.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "NewMessageTipsView.h"

@implementation NewMessageTipsView

- (void)showWithSystemMessageCount:(NSInteger)systemMessageCount inviteCount:(NSInteger)inviteCount teamCount:(NSInteger)teamCount; {
    
    self.systemMessageView.hidden = systemMessageCount<=0;
    self.matchInviteMessageView.hidden = inviteCount<=0;
    self.teamMessageView.hidden = teamCount<=0;
}

@end
