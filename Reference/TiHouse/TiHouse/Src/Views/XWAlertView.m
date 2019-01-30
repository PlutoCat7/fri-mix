//
//  XWAlertView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/12.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "XWAlertView.h"

@interface XWAlertView()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *alertView;

@end

@implementation XWAlertView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        
        _alertView = [[UIView alloc]init];
        _alertView.backgroundColor = [UIColor whiteColor];
        //    _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 12.f;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(44);
            make.right.equalTo(self).offset(-44);
            make.centerY.equalTo(self);
            make.height.equalTo(@(160));
        }];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertView);
            make.right.equalTo(_alertView);
            make.bottom.equalTo(_alertView);
            make.height.equalTo(@(49));
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kLineColer;
        [_alertView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn);
            make.right.equalTo(btn);
            make.bottom.equalTo(btn.mas_top);
            make.height.equalTo(@(0.5));
        }];
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_alertView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_alertView.mas_centerX);
            make.top.equalTo(_alertView.mas_top).offset(25);
            make.height.equalTo(@(40));
            make.width.equalTo(@(40));
        }];
        
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor blackColor];
        [_alertView addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertView).offset(10);
            make.right.equalTo(_alertView).offset(-10);
            make.height.equalTo(@(0));
            make.top.equalTo(_iconImageView.mas_bottom).offset(20);
        }];
        
    }
    return self;
}

-(void)setMessage:(NSString *)message{
    _message = message;
    _messageLabel.text = message;
    CGFloat messageH = [message getHeightWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width-88-20, 200)];
    [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(messageH));
    }];
      [self layoutIfNeeded];
    [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(50+CGRectGetMaxY(_messageLabel.frame)+20));
    }];
    [self layoutIfNeeded];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _iconImageView.image = image;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self showBackground];
    [self showAlertAnimation];
    
}

- (void)hide {
    if (_BtnClikc) {
        _BtnClikc();
    }
    _alertView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}
- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}


@end
