//
//  LaunchAdvertisementView.m
//  YouShuLa
//
//  Created by Teen Ma on 2018/4/3.
//  Copyright © 2018年 YouShuLa_IOS. All rights reserved.
//

#import "LaunchAdvertisementView.h"
#import "LaunchAdvertisementViewModel.h"

@interface LaunchAdvertisementView ()
{
    NSTimer *timer;
}

@property (nonatomic, strong  ) UIImageView  *placeHolderImage;
@property (nonatomic, strong  ) UIView       *bottomView;
@property (nonatomic, strong  ) LaunchAdvertisementViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView *adImageView;
@property (nonatomic, strong  ) UIButton     *timerButton;
@property (nonatomic, strong  ) UIImageView  *bottomImageView;

@end

@implementation LaunchAdvertisementView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    [self addSubview:self.adImageView];
    [self.adImageView addSubview:self.timerButton];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomImageView];
    
    [self addSubview:self.placeHolderImage];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_placeHolderImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_placeHolderImage)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_placeHolderImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_placeHolderImage)]];
    
    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    NSInteger bottomViewHeight = kRKBHEIGHT(100);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_adImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_adImageView][_bottomView(bottomViewHeight)]|" options:0 metrics:@{@"bottomViewHeight":@(bottomViewHeight)} views:NSDictionaryOfVariableBindings(_adImageView,_bottomView)]];
    
    NSInteger kTopSpace = 26;
    if (IphoneX)
    {
        kTopSpace += kNavigationBarTop;
    }
    [self.adImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timerButton(80)]-16-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_timerButton)]];
    [self.adImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(kTopSpace)-[_timerButton(30)]" options:0 metrics:@{@"kTopSpace":@(kTopSpace)} views:NSDictionaryOfVariableBindings(_timerButton)]];
}

- (void)resetViewWithViewModel:(LaunchAdvertisementViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.bottomImageView.image = viewModel.bottomImage;
    self.placeHolderImage.image = viewModel.placeHolderImageView;
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.adImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error)
        {
            self.placeHolderImage.hidden = YES;
            self.adImageView.hidden = NO;
            self.bottomView.hidden = NO;
            self.timerButton.hidden = !viewModel.hasDurationLabel;
            if (viewModel.hasDurationLabel)
            {
                [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",viewModel.duration] forState:UIControlStateNormal];
                
                if (timer)
                {
                    [timer invalidate];
                    timer = nil;
                }

                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(respondsToTimer:) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                [timer fire];
            }
        }
    }];

    self.adImageView.userInteractionEnabled = viewModel.canTouch;
}

- (void)respondsToAdImageView:(UITapGestureRecognizer *)gesture
{
    [timer invalidate];
    timer = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchAdvertisementView:clickAdImageViewWithViewModel:)])
    {
        [self.delegate launchAdvertisementView:self clickAdImageViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToTimer:(NSTimer *)timer
{
    if (self.viewModel.duration > 0)
    {
        [self.timerButton setTitle:[NSString stringWithFormat:@"跳过 %ld",self.viewModel.duration] forState:UIControlStateNormal];
        self.viewModel.duration = self.viewModel.duration - 1;
    }
    else
    {
        [timer invalidate];
        timer = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(launchAdvertisementView:clickDurationTimerLabelWithViewModel:)])
        {
            [self.delegate launchAdvertisementView:self clickDurationTimerLabelWithViewModel:self.viewModel];
        }
    }
}

- (void)respondsToTimerButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchAdvertisementView:clickDurationTimerLabelWithViewModel:)])
    {
        [self.delegate launchAdvertisementView:self clickDurationTimerLabelWithViewModel:self.viewModel];
        self.viewModel.duration = 0;
        [timer invalidate];
        timer = nil;
    }
}

- (UIImageView *)adImageView
{
    if (!_adImageView)
    {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.backgroundColor = [UIColor clearColor];
        _adImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _adImageView.hidden = YES;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAdImageView:)]];
    }
    return _adImageView;
}

- (UIButton *)timerButton
{
    if (!_timerButton)
    {
        _timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _timerButton.backgroundColor = [UIColor clearColor];
        _timerButton.hidden = YES;
        _timerButton.translatesAutoresizingMaskIntoConstraints = NO;
        _timerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_timerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timerButton.layer.cornerRadius = 16;
        _timerButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _timerButton.layer.borderWidth = 1;
        _timerButton.layer.masksToBounds = YES;
        [_timerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _timerButton.backgroundColor = [RGB(81, 87, 87) colorWithAlphaComponent:0.6];
        [_timerButton addTarget:self action:@selector(respondsToTimerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerButton;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [KitFactory view];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
        _bottomView.userInteractionEnabled = YES;
        [_bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAdImageView:)]];
    }
    return _bottomView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView)
    {
        _bottomImageView = [KitFactory imageView];
        _bottomImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomImageView;
}

- (UIImageView *)placeHolderImage
{
    if (!_placeHolderImage)
    {
        _placeHolderImage = [KitFactory imageView];
        _placeHolderImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _placeHolderImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
