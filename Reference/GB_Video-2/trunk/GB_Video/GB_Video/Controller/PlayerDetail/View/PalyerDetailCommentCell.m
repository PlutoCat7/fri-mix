//
//  PalyerDetailCommentCell.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PalyerDetailCommentCell.h"
#import "GBView.h"
#import "UIImageView+WebCache.h"

#import "PlayerDetailCommentCellModel.h"

@interface PalyerDetailCommentCell ()

@property (weak, nonatomic) IBOutlet GBView *avatorView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatorViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopLayoutConstraint;

@end

@implementation PalyerDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.avatorView.cornerRadius = self.avatorView.width/2;
    self.avatorViewTopLayoutConstraint.constant = 22 *kAppScale;
    self.contentLabelTopLayoutConstraint.constant = 60 *kAppScale;
}

- (void)refreshWithModel:(PlayerDetailCommentCellModel *)model {
    
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.userImageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.userNameLabel.text = model.userName;
    self.timeLabel.text = model.timeString;
    self.contentLabel.text = model.commentString;
}

@end
