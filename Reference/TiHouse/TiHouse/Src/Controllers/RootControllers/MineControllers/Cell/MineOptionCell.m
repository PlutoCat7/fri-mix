//
//  MineOptionCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineOptionCell.h"
#import "MineOptionViewModel.h"
#import "MineOptionDetailView.h"

@interface MineOptionCell () <MineOptionDetailViewDelegate>

@property (nonatomic, strong  ) MineOptionViewModel *viewModel;

@property (nonatomic, strong  ) MineOptionDetailView *leftView;
@property (nonatomic, strong  ) MineOptionDetailView *centerView;
@property (nonatomic, strong  ) MineOptionDetailView *rightView;

@end

@implementation MineOptionCell

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
    
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.centerView];
    [self.contentView addSubview:self.rightView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftView][_centerView][_rightView]|" options:NSLayoutFormatAlignAllTop metrics:0 views:NSDictionaryOfVariableBindings(_leftView,_centerView,_rightView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftView)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.centerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
 }

- (void)resetCellWithViewModel:(MineOptionViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.leftView resetViewWithViewModel:viewModel.leftViewModel];
    
    [self.centerView resetViewWithViewModel:viewModel.centerViewModel];
    
    [self.rightView resetViewWithViewModel:viewModel.rightViewModel];
}

- (void)mineOptionDetailView:(MineOptionDetailView *)view clickViewWithViewModel:(MineOptionDetailViewModel *)viewModel;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineOptionCell:clickDetailViewWithViewModel:)])
    {
        [self.delegate mineOptionCell:self clickDetailViewWithViewModel:viewModel];
    }
}

- (MineOptionDetailView *)leftView
{
    if (!_leftView)
    {
        _leftView = [[MineOptionDetailView alloc] initWithFrame:CGRectZero];
        _leftView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftView.delegate = self;
    }
    return _leftView;
}

- (MineOptionDetailView *)centerView
{
    if (!_centerView)
    {
        _centerView = [[MineOptionDetailView alloc] initWithFrame:CGRectZero];
        _centerView.translatesAutoresizingMaskIntoConstraints = NO;
        _centerView.delegate = self;
    }
    return _centerView;
}

- (MineOptionDetailView *)rightView
{
    if (!_rightView)
    {
        _rightView = [[MineOptionDetailView alloc] initWithFrame:CGRectZero];
        _rightView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightView.delegate = self;
    }
    return _rightView;
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
