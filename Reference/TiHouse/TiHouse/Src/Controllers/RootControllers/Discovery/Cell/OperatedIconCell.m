//
//  OperatedIconCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OperatedIconCell.h"
#import "OperatedIconViewModel.h"

@interface OperatedIconCell ()

@property (nonatomic, strong  ) OperatedIconViewModel *viewModel;

@property (nonatomic, strong  ) UIImageView *firstIcon;
@property (nonatomic, strong  ) UILabel     *firstTitleLabel;

@property (nonatomic, strong  ) UIImageView *secondIcon;
@property (nonatomic, strong  ) UILabel     *secondTitleLabel;

@property (nonatomic, strong  ) UIImageView *threeIcon;
@property (nonatomic, strong  ) UILabel     *threeTitleLabel;

@property (nonatomic, strong  ) UIButton    *rightButton;

@end

@implementation OperatedIconCell


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
    
    [self.contentView addSubview:self.firstIcon];
    [self.contentView addSubview:self.firstTitleLabel];
    
    [self.contentView addSubview:self.secondIcon];
    [self.contentView addSubview:self.secondTitleLabel];
    
    [self.contentView addSubview:self.threeIcon];
    [self.contentView addSubview:self.threeTitleLabel];
    
    [self.contentView addSubview:self.rightButton];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.firstIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_firstIcon]-1-[_firstTitleLabel]-32-[_secondIcon]-1-[_secondTitleLabel]-32-[_threeIcon]-1-[_threeTitleLabel]-(>=10)-[_rightButton]-10-|" options:NSLayoutFormatAlignAllBottom metrics:0 views:NSDictionaryOfVariableBindings(_firstIcon,_firstTitleLabel,_secondIcon,_secondTitleLabel,_threeIcon,_threeTitleLabel,_rightButton)]];
}

- (void)resetCellWithViewModel:(OperatedIconViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    self.firstIcon.image = viewModel.firstIcon;
    self.firstTitleLabel.text = viewModel.firstTitle;
    
    self.secondIcon.image = viewModel.secondIcon;
    self.secondTitleLabel.text = viewModel.secondTitle;
    
    self.threeIcon.image = viewModel.thirdIcon;
    self.threeTitleLabel.text = viewModel.thirdTitle;
 
    [self.rightButton setImage:viewModel.rightIcon forState:UIControlStateNormal];
}

- (void)respondsToFirstIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(operatedIconCell:clickFirstIconWithViewModel:)])
    {
        [self.delegate operatedIconCell:self clickFirstIconWithViewModel:self.viewModel];
    }
}

- (void)respondsToSecondIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(operatedIconCell:clickSecondIconWithViewModel:)])
    {
        [self.delegate operatedIconCell:self clickSecondIconWithViewModel:self.viewModel];
    }
}

- (void)respondsToThirdIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(operatedIconCell:clickThirdIconWithViewModel:)])
    {
        [self.delegate operatedIconCell:self clickThirdIconWithViewModel:self.viewModel];
    }
}

- (void)respondsToRightButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(operatedIconCell:clickRightButtonWithViewModel:)])
    {
        [self.delegate operatedIconCell:self clickRightButtonWithViewModel:self.viewModel];
    }
}

- (UIImageView *)firstIcon
{
    if (!_firstIcon)
    {
        _firstIcon = [[UIImageView alloc] init];
        _firstIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _firstIcon.userInteractionEnabled = YES;
        [_firstIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToFirstIcon:)]];
    }
    return _firstIcon;
}

- (UIImageView *)secondIcon
{
    if (!_secondIcon)
    {
        _secondIcon = [[UIImageView alloc] init];
        _secondIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _secondIcon.userInteractionEnabled = YES;
        [_secondIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSecondIcon:)]];
    }
    return _secondIcon;
}

- (UIImageView *)threeIcon
{
    if (!_threeIcon)
    {
        _threeIcon = [[UIImageView alloc] init];
        _threeIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _threeIcon.userInteractionEnabled = YES;
        [_threeIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToThirdIcon:)]];
    }
    return _threeIcon;
}

- (UILabel *)firstTitleLabel
{
    if (!_firstTitleLabel)
    {
        _firstTitleLabel = [KitFactory label];
        _firstTitleLabel.backgroundColor = [UIColor clearColor];
        _firstTitleLabel.textColor = RGB(153, 153, 153);
        _firstTitleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _firstTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _firstTitleLabel.userInteractionEnabled = YES;
        [_firstTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToFirstIcon:)]];
    }
    return _firstTitleLabel;
}

- (UILabel *)secondTitleLabel
{
    if (!_secondTitleLabel)
    {
        _secondTitleLabel = [KitFactory label];
        _secondTitleLabel.backgroundColor = [UIColor clearColor];
        _secondTitleLabel.textColor = RGB(153, 153, 153);
        _secondTitleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _secondTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _secondTitleLabel.userInteractionEnabled = YES;
        [_secondTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSecondIcon:)]];
    }
    return _secondTitleLabel;
}

- (UILabel *)threeTitleLabel
{
    if (!_threeTitleLabel)
    {
        _threeTitleLabel = [KitFactory label];
        _threeTitleLabel.backgroundColor = [UIColor clearColor];
        _threeTitleLabel.textColor = RGB(153, 153, 153);
        _threeTitleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _threeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _threeTitleLabel.userInteractionEnabled = YES;
        [_threeTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToThirdIcon:)]];
    }
    return _threeTitleLabel;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [KitFactory button]; 
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightButton addTarget:self action:@selector(respondsToRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
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
