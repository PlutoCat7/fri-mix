//
//  NewMessageTipsView.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXTView.h"
#import "XXNibBridge.h"

@interface NewMessageTipsView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet EXTView *systemMessageView;
@property (weak, nonatomic) IBOutlet EXTView *matchInviteMessageView;
@property (weak, nonatomic) IBOutlet EXTView *teamMessageView;

- (void)showWithSystemMessageCount:(NSInteger)systemMessageCount inviteCount:(NSInteger)inviteCount teamCount:(NSInteger)teamCount;

@end
