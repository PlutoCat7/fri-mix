//
//  PieView.m
//  TiHouse
//
//  Created by gaodong on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PieView.h"

@interface PieView()

@property (retain, nonatomic) UILabel *lblSum;
@property (retain, nonatomic) UILabel *lblTitle;

@end

@implementation PieView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    
    _lblSum = [[UILabel alloc] initWithFrame:CGRectZero];
    [_lblSum setTextColor:XWColorFromHex(0xfec00c)];
    [_lblSum setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
    [self addSubview:_lblSum];
    [_lblSum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-10);
    }];
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblTitle.text = @"总支出";
    [_lblTitle setTextColor:[UIColor darkGrayColor]];
    [_lblTitle setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_lblTitle];
    [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(15);
    }];
    
}

- (void)drawPieWithNumbers:(NSArray *)numArray
                     price:(NSNumber *)price
                  isPay:(BOOL)ispay{

    
    NSArray *colorArray = @[XWColorFromHex(0x9bd0ac),
                            XWColorFromHex(0xcd8fb1),
                            XWColorFromHex(0xfcd586),
                            XWColorFromHex(0x8fdbd7),
                            XWColorFromHex(0xf7d8c1)];
    NSArray *iconArray = @[[UIImage imageNamed:@"account_sum1"],[UIImage imageNamed:@"account_sum2"],[UIImage imageNamed:@"account_sum3"],[UIImage imageNamed:@"account_sum4"],[UIImage imageNamed:@"account_sum5"]];
    
    
    BOOL isEmpty = YES;
    for (NSNumber *n in numArray) {
        if (!isnan([n floatValue])) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        numArray = @[@100,@0,@0,@0,@0];
        colorArray = @[XWColorFromHex(0xffffff),
                       XWColorFromHex(0xffffff),
                       XWColorFromHex(0xffffff),
                       XWColorFromHex(0xffffff),
                       XWColorFromHex(0xffffff)];
        iconArray = @[[UIImage imageWithColor:[UIColor whiteColor]],
                      [UIImage imageWithColor:[UIColor whiteColor]],
                      [UIImage imageWithColor:[UIColor whiteColor]],
                      [UIImage imageWithColor:[UIColor whiteColor]],
                      [UIImage imageWithColor:[UIColor whiteColor]]
                      ];
    }
    
    // 线条宽度
    CGFloat lineWidth = 37;
    // 半径
    CGFloat radiusW = (self.bounds.size.width - lineWidth*2)/2 ;
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    
    
    NSInteger index = 0;
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    
    // layer
    for (NSNumber *number in numArray) {
        CGFloat e = [number floatValue];
        
        CAShapeLayer *layer1 = [CAShapeLayer layer];
        layer1.frame = self.bounds;
        layer1.fillColor = [UIColor clearColor].CGColor;
        layer1.lineWidth = lineWidth;
        UIColor *c = colorArray[index];
        layer1.strokeColor = c.CGColor;
        [layer addSublayer:layer1];
        
        
        // 计算结束的角度
        startAngle = endAngle;
        endAngle = endAngle + (M_PI * 2 * (e/100));
        
        // 园弧路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:layer1.position radius:radiusW startAngle:startAngle endAngle:endAngle clockwise:YES];
        layer1.path = path.CGPath;
        
        // 色环上的图标
        CALayer *icon = [CALayer layer];
        UIImage *img = iconArray[index];
        icon.contents = (__bridge id _Nullable)(img.CGImage);
        icon.frame = CGRectMake(0, 0, 24, 24);
        // 超过10%添加icon
        if (e > 10) {
            [layer addSublayer:icon];
        }
        
        // 图标在角度中间位置
        CGFloat end =  startAngle + (endAngle - startAngle) *.5;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:layer1.position radius:radiusW startAngle:startAngle endAngle:end clockwise:YES];
        // 利用CAKeyframeAnimation path来移动图标位置
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.duration = 0.01;
        animation.path = path1.CGPath;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        //animation.rotationMode = kCAAnimationRotateAuto;
        [icon addAnimation:animation forKey:nil];
        
        index++;
        
    }
    
    
    //蒙版
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:layer.position radius:radiusW startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = self.bounds;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineJoin = kCALineCapRound;
    maskLayer.lineWidth = lineWidth;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    layer.mask = maskLayer;
    [self.layer addSublayer:layer];
    
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.duration = 0.5;
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.fillMode = kCAFillModeForwards;
    ani.removedOnCompletion = NO;
    [maskLayer addAnimation:ani forKey:@"strokeEndAnimation"];
    
    _lblSum.text = [price stringValue];
    _lblSum.textColor = ispay? XWColorFromHex(0xfec00c):XWColorFromHex(0x11c354);
    _lblTitle.text = ispay? @"总支出":@"总退款";
}

@end

