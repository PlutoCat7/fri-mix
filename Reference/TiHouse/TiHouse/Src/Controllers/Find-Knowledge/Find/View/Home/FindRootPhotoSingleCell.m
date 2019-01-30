//
//  FindRootPhotoSingleCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindRootPhotoSingleCell.h"
#import "FindAssemarcInfo.h"
#import "Login.h"

#define FullTextButtonHeight 20

@interface FindRootPhotoSingleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullButtonHeightLayout;


@property (nonatomic, strong) FindAssemarcInfo *arcInfo;

@end

@implementation FindRootPhotoSingleCell

- (CGFloat)getHeightWithArcInfo:(FindAssemarcInfo *)info {
    
    CGFloat topViewHeight = kRKBWIDTH(55);
    CGFloat bottomViewHeight = kRKBWIDTH(47);
    CGFloat paddingViewHeight = kRKBWIDTH(15);
    
    NSString *content = info.assemarctitle;
    
    NSString *fourLineString = @"test\ntest\ntest\ntest";
    CGFloat fourHeight = [fourLineString getHeightWithFont:self.photoTitleLabel.font constrainedToSize:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
    
    if (!info.assemtitle ||
        [info.assemtitle isEmpty]) {
        self.photoTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:content];
    }else {
        NSString *assemTitle = [NSString stringWithFormat:@"#%@#", info.assemtitle];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", assemTitle, content]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kRKBWIDTH(13)] range:NSMakeRange(0, [attributedString string].length)];
        self.photoTitleLabel.attributedText = [attributedString copy];
    }
    CGFloat contentHeight = [[self.photoTitleLabel.attributedText string] getHeightWithFont:self.photoTitleLabel.font constrainedToSize:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
    info.isMoreFourLine = contentHeight>fourHeight;
    CGFloat titleHeight = 0;
    if (info.isMoreFourLine) {
        if (info.isFullText) {
            titleHeight = contentHeight;
        }else {
            titleHeight = fourHeight;
        }
    }else {
        titleHeight = contentHeight;
    }
    
    CGFloat imageHeight = kRKBWIDTH(351);
    
    return topViewHeight + 14 + titleHeight + 15 +  (info.isMoreFourLine?FullTextButtonHeight:0) + imageHeight + bottomViewHeight + paddingViewHeight;
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

#pragma mark - Public

- (void)refreshWithInfo:(FindAssemarcInfo *)info {
    
    self.arcInfo = info;
    
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    self.userNameLabel.text = info.username;
    self.dateLabel.text = info.createtimeStr;
    [self.attentionButton setImage:info.assemarcisconcern?nil:[UIImage imageNamed:@"find_add_attention"] forState:UIControlStateNormal];
    [self.attentionButton setTitle:info.assemarcisconcern?@"已关注":@"关注" forState:UIControlStateNormal];
    self.attentionButton.backgroundColor = info.assemarcisconcern?[UIColor colorWithRGBHex:0xEFEFEF]:kTiMainBgColor;
    self.attentionButton.hidden = [Login curLoginUser].uid == info.assemarcuid;  //自己的文章隐藏关注按钮
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:info.assemarcfileJA.firstObject.assemarcfileurl]];
    self.tagImageView.hidden = !(info.assemarcfileJA.firstObject.assemarcfiletagJA.count>0);
    NSString *content = info.assemarctitle;
    if (!info.assemtitle ||
        [info.assemtitle isEmpty]) {
        self.photoTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:content];
    }else {
        NSString *assemTitle = [NSString stringWithFormat:@"#%@#", info.assemtitle];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", assemTitle, content]];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRGBHex:0xFEC00C]
                                 range:[[attributedString string] rangeOfString:assemTitle]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kRKBWIDTH(13)] range:NSMakeRange(0, [attributedString string].length)];
        self.photoTitleLabel.attributedText = [attributedString copy];
    }
    self.photoTitleLabel.numberOfLines = info.isFullText?0:4;
    [self.photoTitleLabel sizeThatFits:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
    self.fullButton.selected = info.isFullText;
    self.fullButton.hidden = !info.isMoreFourLine;
    self.fullButtonHeightLayout.constant = info.isMoreFourLine?FullTextButtonHeight:0;
    
    self.likeButton.selected = info.assemarciszan;
    [self.likeButton setTitle:@(info.assemarcnumzan).stringValue forState:UIControlStateNormal];
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

- (IBAction)actionImageClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionImageClick:imageIndex:)]) {
        [_delegate findRootCellaAtionImageClick:self imageIndex:0];
    }
}

- (IBAction)ckeckFullText:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.arcInfo.isFullText = !self.arcInfo.isFullText;
    //通知页面刷新
    if (self.needRefreshView) {
        self.needRefreshView();
    }
}

@end
