//
//  FindRootArticelCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindRootArticelCell.h"
#import "FindAssemarcInfo.h"
#import "Login.h"

#define kTopPadding 15
#define kBottomPadding 25

@interface FindRootArticelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleSubTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayout;

@end

@implementation FindRootArticelCell

- (CGFloat)getHeightWithSubTitle:(NSString *)subTitle {
    
    CGFloat topViewHeight = kRKBWIDTH(55);
    CGFloat bottomViewHeight = kRKBWIDTH(47);
    CGFloat paddingViewHeight = kRKBWIDTH(15);
    
    self.articleSubTitleLabel.text = subTitle;
    [self.articleSubTitleLabel sizeToFit];
    
    return topViewHeight + kTopPadding + self.articleSubTitleLabel.bottom + kBottomPadding + bottomViewHeight + paddingViewHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.avatorImageView.layer.cornerRadius = self.avatorImageView.height/2;
    });
}

- (void)refreshWithInfo:(FindAssemarcInfo *)info {
    
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    self.userNameLabel.text = info.username;
    self.dateLabel.text = info.createtimeStr;
    [self.attentionButton setImage:info.assemarcisconcern?nil:[UIImage imageNamed:@"find_add_attention"] forState:UIControlStateNormal];
    [self.attentionButton setTitle:info.assemarcisconcern?@"已关注":@"关注" forState:UIControlStateNormal];
    self.attentionButton.backgroundColor = info.assemarcisconcern?[UIColor colorWithRGBHex:0xEFEFEF]:kTiMainBgColor;
    self.attentionButton.hidden = [Login curLoginUser].uid == info.assemarcuid;  //自己的文章隐藏关注按钮
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:info.urlindex]];
    self.articleTitleLabel.text = info.assemarctitle;
    self.articleSubTitleLabel.text = info.assemarctitlesub;
    [self.articleSubTitleLabel sizeToFit];
    self.contentViewHeightLayout.constant = kTopPadding +  self.articleSubTitleLabel.bottom + kBottomPadding;
    
    self.likeButton.selected = info.assemarciszan;
    self.collectionButton.selected = info.assemarciscoll;
    [self.likeButton setTitle:@(info.assemarcnumzan).stringValue forState:UIControlStateNormal];
    [self.collectionButton setTitle:@(info.assemarcnumcoll).stringValue forState:UIControlStateNormal];
    [self.commentButton setTitle:@(info.assemarcnumcomm).stringValue forState:UIControlStateNormal];
    
}

#pragma mark - Action

- (IBAction)actionAttention:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionAttention:)]) {
        [_delegate findRootCellaAtionAttention:self];
    }
}

- (IBAction)actionLike:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionLike:)]) {
        [_delegate findRootCellaAtionLike:self];
    }
}

- (IBAction)actonCollection:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionAttention:)]) {
        [_delegate findRootCellaAtionAttention:self];
    }
}

- (IBAction)actionComment:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionComment:)]) {
        [_delegate findRootCellaAtionComment:self];
    }
}

- (IBAction)actionShare:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionShare:)]) {
        [_delegate findRootCellaAtionShare:self];
    }
}

@end
