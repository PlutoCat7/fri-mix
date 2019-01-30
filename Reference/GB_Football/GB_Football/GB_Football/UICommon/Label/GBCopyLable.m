//
//  GBCopyLable.m
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBCopyLable.h"

@implementation GBCopyLable

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self attachTapHandler];
    
}

-(void)attachTapHandler {
    self.userInteractionEnabled = YES;  //用户交互的总开关
    
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    [self addGestureRecognizer:touch];
    
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    
    [self becomeFirstResponder];
    
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:LS(@"common.copy") action:@selector(copyLink:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyLink:));
}

-(void)copyLink:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

@end
