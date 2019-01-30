//
//  AdverHeadView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AdverHeadView.h"
#import "AdverHeadViewModel.h"

@interface AdverHeadView ()

@property (nonatomic, strong  ) AdverHeadViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView *largeView;
@property (nonatomic, strong  ) UILabel     *topRightLabel;

@end

@implementation AdverHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAdverHeadView:)]];
    [self addSubview:self.largeView];
    [self addSubview:self.topRightLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_largeView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_largeView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeView)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topRightLabel(18)]-5-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_topRightLabel(10)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightLabel)]];
}

- (void)resetViewWithViewModel:(AdverHeadViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.largeView sd_setImageWithURL:[NSURL URLWithString:viewModel.adv_imageUrl] placeholderImage:viewModel.placeHolder];
    
    self.topRightLabel.text = viewModel.topRightTitle;
}

- (UIImageView *)largeView
{
    if (!_largeView)
    {
        _largeView = [[UIImageView alloc] init];
        _largeView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _largeView;
}

- (UILabel *)topRightLabel
{
    if (!_topRightLabel)
    {
        _topRightLabel = [[UILabel alloc] init];
        _topRightLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.32];
        _topRightLabel.layer.cornerRadius = 5;
        _topRightLabel.layer.masksToBounds = YES;
        _topRightLabel.font = [UIFont systemFontOfSize:6];
        _topRightLabel.textColor = [UIColor whiteColor];
        _topRightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _topRightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topRightLabel;
}

- (void)respondsToAdverHeadView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(adverHeadView:clickLargeImageWithViewModel:)])
    {
        [self.delegate adverHeadView:self clickLargeImageWithViewModel:self.viewModel];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
