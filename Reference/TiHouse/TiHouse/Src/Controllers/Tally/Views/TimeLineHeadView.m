//
//  TimeLineHeadView.m
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TimeLineHeadView.h"


@interface TimeLineHeadView()

@property (nonatomic, retain) CAReplicatorLayer *replicatorLayer_Circle;
@property (retain, nonatomic) UIView *icon;
@property (retain, nonatomic) UIImageView *iconClock;

@end

@implementation TimeLineHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [TallyHelper labelSize:_day.text font:[UIFont systemFontOfSize:12] height:20];
    [_day mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+2);
        make.height.mas_equalTo(size.height);
    }];
    [_week mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_day.mas_right);
    }];
    
    if (_idx > 0) {
        [_icon setHidden:NO];
        [_iconClock setHidden:YES];
    }else{
        [_icon setHidden:YES];
        [_iconClock setHidden:NO];
    }
}

- (void)addSubviews{
    
    //整体内容view
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
    [v setBackgroundColor:kRKBViewControllerBgColor];
    
    //线条
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kLineColer;
    [v addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(18));
        make.top.and.bottom.equalTo(v);
        make.width.equalTo(@(1));
    }];
    
    //圆点icon
    _icon = [[UIView alloc]init];
    _icon.backgroundColor = kRKBViewControllerBgColor;
    [_icon.layer addSublayer:[self replicatorLayer_Circle]];
    [v addSubview:_icon];
    CALayer *layer = [[CALayer alloc]init];
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    layer.cornerRadius = 2.0;
    layer.frame = CGRectMake(6, 6, 4, 4);
    [_icon.layer addSublayer:layer];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_centerX);
        make.bottom.equalTo(line).offset(-5);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _iconClock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_clock"]];
    [v addSubview:_iconClock];
    [_iconClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line.mas_centerX);
        make.bottom.equalTo(line).offset(-8);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    _day = [[UILabel alloc]init];
    _day.font = [UIFont fontWithName:@"Heiti SC" size:12];
    _day.textColor = kRKBNAVBLACK;
    _day.numberOfLines = 1;
    [v addSubview:_day];
    [_day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(4);
        make.centerY.equalTo(_icon.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    _week = [[UILabel alloc]init];
    _week.font = [UIFont fontWithName:@"Heiti SC" size:10];
    _week.textColor = XWColorFromHex(0xbfbfbf);
    _week.numberOfLines = 1;
    [v addSubview:_week];
    [_week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_day.mas_right);
        make.centerY.equalTo(_day.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    
    [self addSubview:v];
}

// 圆圈动画 波纹
- (CALayer *)replicatorLayer_Circle{
    
    if (!_replicatorLayer_Circle) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, 16, 16);
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 16, 16)].CGPath;
        shapeLayer.fillColor = [UIColor orangeColor].CGColor;
        shapeLayer.opacity = 0.0;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
        animationGroup.duration = 2.0;
        animationGroup.autoreverses = NO;
        animationGroup.repeatCount = HUGE;
        [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
        
        _replicatorLayer_Circle = [CAReplicatorLayer layer];
        _replicatorLayer_Circle.frame = CGRectMake(0, 0, 16, 16);
        _replicatorLayer_Circle.instanceDelay = 0.5;
        _replicatorLayer_Circle.instanceCount = 4;
        [_replicatorLayer_Circle addSublayer:shapeLayer];
    }
    return _replicatorLayer_Circle;
}

- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}

- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    return scale;
}

@end
