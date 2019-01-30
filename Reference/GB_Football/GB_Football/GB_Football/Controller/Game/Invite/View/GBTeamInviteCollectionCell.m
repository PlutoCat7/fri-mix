//
//  GBTeamInviteCollectionCell.m
//  GB_Football
//
//  Created by gxd on 17/8/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamInviteCollectionCell.h"

@implementation GBTeamInviteCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatorImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.avatorImageView.layer setCornerRadius:self.avatorImageView.width/2];
        [self.avatorImageView.layer setMasksToBounds:YES];
    });
}

@end
