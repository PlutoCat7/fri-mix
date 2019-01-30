//
//  FindAssemCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemCell.h"
#import "UIImageView+WebCache.h"

@interface FindAssemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *assemurlindexImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;  //FCBF2F   DBDBDB
@property (weak, nonatomic) IBOutlet UILabel *assemtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *userAvatorContainerView;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCountLabelLeftLayout;
@property (nonatomic, strong) UIView *userView;

@end

@implementation FindAssemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithInfo:(AssemCellModel *)model {
    
    [self.assemurlindexImageView sd_setImageWithURL:[NSURL URLWithString:model.assemurlindex]];
    self.statusLabel.text = model.assemstatus==1?@"正在征集":@"征集结束";
    self.statusLabel.backgroundColor = model.assemstatus==1?[UIColor colorWithRGBHex:0xFCBF2F]:[UIColor colorWithRGBHex:0xDBDBDB];
    self.assemtitleLabel.text = model.assemtitle;
    
    [self setupUserView:model];
}

- (void)setupUserView:(AssemCellModel *)model {
    
    [self.userView removeFromSuperview];
    
    CGFloat padding = 7;
    UIView *userView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.userAvatorContainerView addSubview:userView];
    CGFloat left = kRKBWIDTH(12);
    
    for (FindAssemUserInfo *info in model.userList) {
        UIView *avatorView = [self userAvatorView:info image:nil];
        avatorView.left = left;
        [userView addSubview:avatorView];
        userView.height = avatorView.height;
        
        left = avatorView.right - padding;
    }
    if (model.totalUserCount >4 ) { //显示更多图标
        UIView *avatorView = [self userAvatorView:nil image:[UIImage imageNamed:@"find_assem_more_user"]];
        avatorView.left = left;
        [userView addSubview:avatorView];
        
        left = avatorView.right - padding;
    }
    userView.width = left+padding;
    userView.centerY = self.userAvatorContainerView.height/2;
    self.userView = userView;
    
    self.userCountLabel.text = [NSString stringWithFormat:@"%td人参加征集", model.totalUserCount];
    self.userCountLabelLeftLayout.constant = userView.right;
}

- (UIView *)userAvatorView:(FindAssemUserInfo *)info image:(UIImage *)image {
    
    CGFloat avatorViewWidth = kRKBWIDTH(30);
    CGFloat padding = 2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, avatorViewWidth+padding*2, avatorViewWidth+padding*2)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, avatorViewWidth, avatorViewWidth)];
    if (image) {
        imageView.image = image;
    }else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    }
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = avatorViewWidth/2;
    [view addSubview:imageView];
    
    return view;
}

#pragma mark - Action

- (IBAction)actionEnter:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(findAssemCellDidSelected:)]) {
        [_delegate findAssemCellDidSelected:self];
    }
}

@end
