//
//  MorelLineLabelWithBackgroundCell.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "MorelLineLabelWithBackgroundCell.h"
#import "MorelLineLabelWithBackgroundViewModel.h"

#define kLeft_RightContentViewModelSpace 10

@interface MorelLineLabelWithBackgroundCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) MorelLineLabelWithBackgroundViewModel *viewModel;
@property (nonatomic, strong) UIView *tmpBackgroundView;

@end

@implementation MorelLineLabelWithBackgroundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    [self.contentView addSubview:self.tmpBackgroundView];
    [self.contentView addSubview:self.contentLabel];
}

- (void)resetCellWithViewModel:(MorelLineLabelWithBackgroundViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
    
    self.contentLabel.numberOfLines = model.lineNumber;
    self.contentLabel.text = model.text;
    self.contentLabel.font = [UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:model.font]];
    self.contentLabel.textColor = model.textColor;
    self.contentLabel.textAlignment = model.textAlignment;
    
    self.tmpBackgroundView.backgroundColor = model.backgroundViewColor;
    
    self.backgroundColor = model.cellBackgroundColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tmpBackgroundView.frame = CGRectMake(self.viewModel.backgoundViewLeftRightSpace, 0, self.contentView.frame.size.width - self.viewModel.backgoundViewLeftRightSpace * 2, self.contentView.frame.size.height);
    self.contentLabel.frame = CGRectMake(self.viewModel.leftSpace, 0, self.contentView.frame.size.width - self.viewModel.leftSpace - self.viewModel.rightSpace, self.viewModel.moreLineLabelHeight);
    self.contentLabel.center = CGPointMake(self.contentLabel.center.x, self.contentView.frame.size.height/2);
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [KitFactory label];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

- (UIView *)tmpBackgroundView
{
    if (!_tmpBackgroundView)
    {
        _tmpBackgroundView = [KitFactory view];
    }
    return _tmpBackgroundView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
