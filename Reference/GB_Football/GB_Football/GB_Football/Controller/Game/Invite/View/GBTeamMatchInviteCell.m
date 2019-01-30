//
//  GBTeamMatchInviteCell.m
//  GB_Football
//
//  Created by gxd on 17/8/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamMatchInviteCell.h"

@interface GBTeamMatchInviteCell()
@property (weak, nonatomic) IBOutlet UILabel *staticPosLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatorContainerView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation GBTeamMatchInviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
        [self.avatorContainerView.layer setCornerRadius:self.avatorContainerView.width/2];
    });
}

- (void)setType:(TeamGameInviteType)type {
    
    _type = type;
    switch (type) {
        case TeamGameInviteType_Selected:
            self.selectImageView.image = [UIImage imageNamed:@"invite_checkboxmark"];
            self.selectImageView.hidden = NO;
            self.coverView.hidden = YES;
            break;
        case TeamGameInviteType_NotSelected:
            self.selectImageView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        case TeamGameInviteType_UnSelected:
            self.selectImageView.image = [UIImage imageNamed:@"invite_checkboxmark_x"];
            self.selectImageView.hidden = NO;
            self.coverView.hidden = YES;
            break;
            
        default:
            break;
    }
}

@end
