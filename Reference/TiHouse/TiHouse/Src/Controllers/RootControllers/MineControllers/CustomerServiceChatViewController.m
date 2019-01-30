//
//  RCConversationViewController.m
//  TiHouse
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CustomerServiceChatViewController.h"
#import "RongIMKit/RCMessageCell.h"
#import "RongIMKit/RCTextMessageCell.h"
#import "RongIMKit/RCVoiceMessageCell.h"
#import "RongIMKit/RCIM.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation CustomerServiceChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"有数啦客服";
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    self.conversationType = ConversationType_CUSTOMERSERVICE;
    RCChatSessionInputBarControl *chatSessionInputBarControl = [self chatSessionInputBarControl];
    [chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    [chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    chatSessionInputBarControl.backgroundColor = kColorWhite;
    RCTextView *txtView = [chatSessionInputBarControl inputTextView];
    [txtView setBackgroundColor:XWColorFromHex(0xEBEBEB)];
    [txtView setBorderColor:kColorWhite];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    RCMessageModel *m = [cell model];
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
//        textCell.textLabel.textColor = kColorWhite;
    } else if ([cell isMemberOfClass:[RCVoiceMessageCell class]]) {
        RCVoiceMessageCell *voiceCell = (RCVoiceMessageCell *)cell;
        voiceCell.voiceDurationLabel.textColor = [UIColor whiteColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

@end
