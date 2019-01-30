//
//  SettingAvatorTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingAvatorTableViewCell.h"

@interface SettingAvatorTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SettingAvatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.bgView.backgroundColor = highlighted?[UIColor colorWithHex:0x202020 andAlpha:0.5]:[UIColor colorWithHex:0x202020];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.avatorContainerView.layer.cornerRadius = self.avatorContainerView.width/2;
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
}

- (void)hideArrowImageView:(BOOL)hide {
    
    self.arrowWidthConstraint.constant = hide?0:9;
    self.descSpaceConstraint.constant = hide?0:10;
}

@end
