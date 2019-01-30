//
//  SettingTextTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingTextTableViewCell.h"

@interface SettingTextTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SettingTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.bgView.backgroundColor = highlighted?[UIColor colorWithHex:0xffffff andAlpha:0.5]:[UIColor colorWithHex:0xffffff];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideArrowImageView:(BOOL)hide {
    
    self.arrowWidthConstraint.constant = hide?0:9;
    self.descSpaceConstraint.constant = hide?0:10;
}

@end
