//
//  SettingMutilTextTableViewCell.m
//  GB_Football
//
//  Created by gxd on 17/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingMutilTextTableViewCell.h"

@interface SettingMutilTextTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SettingMutilTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.bgView.backgroundColor = highlighted?[UIColor colorWithHex:0x202020 andAlpha:0.5]:[UIColor colorWithHex:0x202020];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideArrowImageView:(BOOL)hide {
    
    self.arrowWidthConstraint.constant = hide?0:9;
    self.descSpaceConstraint.constant = hide?0:10;
}

- (void)setIntroductionText:(NSString *)content {
    //获得当前cell高度
    CGRect frame = [self frame];
    CGRect titleFrame = self.titleLabel.frame;
    //文本赋值
    self.titleLabel.text = content;
    //设置label的最大行数
    self.titleLabel.numberOfLines = 5;
    CGRect labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(titleFrame.size.width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, labelSize.size.width, labelSize.size.height);
    
    //计算出自适应的高度
    CGFloat height = labelSize.size.height+30 < 50 ? 50 : labelSize.size.height+30;
    frame.size.height = height;
    
    self.frame = frame;

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
