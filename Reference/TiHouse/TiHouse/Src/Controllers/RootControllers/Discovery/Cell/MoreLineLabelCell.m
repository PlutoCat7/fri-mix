//
//  MoreLineLabelCell.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "MoreLineLabelCell.h"
#import "MoreLineLabelViewModel.h"
#import "TTTAttributedLabel.h"

#define kLeft_RightContentViewModelSpace 10

@interface MoreLineLabelCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) MoreLineLabelViewModel *viewModel;

@end

@implementation MoreLineLabelCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.contentLabel];
}

- (void)resetCellWithViewModel:(MoreLineLabelViewModel *)model
{
    [super resetCellWithViewModel:model];

    self.viewModel = model;

    self.contentLabel.numberOfLines = model.lineNumber;
    self.contentLabel.textAlignment = model.textAlignment;
    self.contentLabel.textColor = model.textColor;
    self.contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:model.font]];
    self.contentLabel.text = model.text;

    self.contentView.userInteractionEnabled = model.canCopy;
    
    if (model.topicString.length > 0)
    {
        NSRange topicRange = [model.text rangeOfString:model.topicString];
        
        [self.contentLabel setText:model.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                            value:RGB(254, 192, 12)
                                            range:topicRange];
            return mutableAttributedString;
        }];
        
        [self.contentLabel addLinkToURL:[NSURL URLWithString:@""] withRange:topicRange];
      
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(self.viewModel.leftSpace, 0, self.contentView.frame.size.width - self.viewModel.leftSpace - self.viewModel.rightSpace, self.viewModel.currentCellHeight);
}

- (TTTAttributedLabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.delegate = self;
        _contentLabel.lineSpacing = 10;
        _contentLabel.linkAttributes = @{NSForegroundColorAttributeName:RGB(254, 192, 12),NSUnderlineStyleAttributeName:@(0)};
        _contentLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:RGB(254, 192, 12),NSUnderlineStyleAttributeName:@(0)};
    }
    return _contentLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreLineLabelCell:clickTopicStringWithViewModel:)])
    {
        [self.delegate moreLineLabelCell:self clickTopicStringWithViewModel:self.viewModel];
    }
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
