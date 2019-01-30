//
//  FindRootPhotoMutiCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindRootPhotoMutiCell.h"
#import "FindAssemarcInfo.h"
#import "Login.h"

#define FullTextButtonHeight 20
#define kImageViewPadding kRKBWIDTH(3)
#define kImageCol 3
#define kImageWidth ((kRKBWIDTH(351)-(kImageCol-1)*kImageViewPadding)/kImageCol)

@interface FindRootPhotoMutiCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullButtonHeightLayout;

@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *imageButtonList;

@property (nonatomic, strong) FindAssemarcInfo *arcInfo;

@end

@implementation FindRootPhotoMutiCell


- (CGFloat)getHeightWithArcInfo:(FindAssemarcInfo *)info {
    
    CGFloat topViewHeight = kRKBWIDTH(55);
    CGFloat bottomViewHeight = kRKBWIDTH(47);
    CGFloat paddingViewHeight = kRKBWIDTH(15);
    
    NSString *fourLineString = @"test\ntest\ntest\ntest";
    CGFloat fourHeight = [fourLineString getHeightWithFont:self.photoTitleLabel.font constrainedToSize:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
    
    NSString *content = info.assemarctitle;
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
    
    //取整
    NSInteger sections = ceil((info.assemarcfileJA.count*1.0f)/kImageCol);
    CGFloat imageHeight =  kImageWidth*sections + (sections-1)*kImageViewPadding;
    
    return topViewHeight + 14 + titleHeight + 15 +(info.isMoreFourLine?FullTextButtonHeight:0) + imageHeight + bottomViewHeight + paddingViewHeight;
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
    
    NSArray *subViews = self.imageContainerView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    [self.imageButtonList removeAllObjects];
    for (NSInteger index=0; index<info.assemarcfileJA.count; index++) {
        NSString *url = info.assemarcfileJA[index].assemarcfileurl;
        UIButton *imageButton = [self imageButtonWithUrl:url index:index isTag:info.assemarcfileJA[index].assemarcfiletagJA.count>0];
        NSInteger sections = (index/kImageCol);
        NSInteger col = (index%kImageCol);
        CGFloat y = (sections==0)?0:sections*kImageViewPadding+sections*kImageWidth;
        CGFloat x = (col==0)?0:col*kImageWidth+col*kImageViewPadding;
        imageButton.top = y;
        imageButton.left = x;
        
        [self.imageContainerView addSubview:imageButton];
        [self.imageButtonList addObject:imageButton];
    }
}

#pragma mark - Private

- (UIButton *)imageButtonWithUrl:(NSString *)url index:(NSInteger)index isTag:(BOOL)isTag {
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.size = CGSizeMake(kImageWidth, kImageWidth);
    imageButton.tag = index;
    [imageButton addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    [imageButton addSubview:imageView];
    
    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageWidth-6-15, 6, 15, 15)];
    tagImageView.hidden = !isTag;
    [tagImageView setImage:[UIImage imageNamed:@"find_photo_plabel"]];
    [imageButton addSubview:tagImageView];
    
    
    return imageButton;
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

- (void)imageViewClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    if ([_delegate respondsToSelector:@selector(findRootCellaAtionImageClick:imageIndex:)]) {
        [_delegate findRootCellaAtionImageClick:self imageIndex:index];
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

#pragma mark - Setter and Getter

- (NSMutableArray *)imageButtonList {
    
    if (!_imageButtonList) {
        _imageButtonList = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageButtonList;
}

@end
