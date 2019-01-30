//
//  GBMatchInviteNotAcceptFriendCollectionCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMatchInviteNotAcceptFriendCollectionCell.h"

@interface GBMatchInviteNotAcceptFriendCollectionCell ()

@end

@implementation GBMatchInviteNotAcceptFriendCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatorImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.inviteButton.layer.cornerRadius = 3.0f;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.avatorImageView.layer setCornerRadius:self.avatorImageView.width/2];
        [self.avatorImageView.layer setMasksToBounds:YES];
    });
}

- (IBAction)actionRetry:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClcikRetryInviteButton:)]) {
        [self.delegate didClcikRetryInviteButton:self];
    }
}

@end
