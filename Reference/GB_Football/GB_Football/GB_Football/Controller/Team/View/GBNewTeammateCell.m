//
//  GBFriendInviteCell.m
//  GB_Football
//
//  Created by Pizza on 16/8/16.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBNewTeammateCell.h"
#import "UIImageView+WebCache.h"

@interface GBNewTeammateCell()
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 分隔线
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
// 名称标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GBNewTeammateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImageView.clipsToBounds = YES;
    [self.refuseBtn setTitle:LS(@"common.btn.refuse") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
        
        self.acceptBtn.layer.cornerRadius = 4.0f;
        self.refuseBtn.layer.cornerRadius = 4.0f;
    });
}

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl {
    
    self.nameLabel.text = name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    [self setNeedsDisplay];
}

// 点击了接受按钮
- (IBAction)actionAcept:(id)sender {

    if ([self.delegate respondsToSelector:@selector(didAcceptCell:)]) {
        [self.delegate didAcceptCell:self];
    }
}

- (IBAction)actionRefuse:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didRefuseCell:)]) {
        [self.delegate didRefuseCell:self];
    }
}

@end
