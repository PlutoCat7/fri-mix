//
//  GuidanceView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GuidanceView.h"

@interface GuidanceView()

@property (nonatomic, retain) UIBezierPath *path;
@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UIButton *clickBtn;

@end

@implementation GuidanceView

-(instancetype)init{
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
        //create path 重点来了（**这里需要添加第一个路径）
        _path = [UIBezierPath bezierPathWithRect:self.frame];
        _shapeLayer = [CAShapeLayer layer];
        _imageV = [[UIImageView alloc]init];
        _imageV.frame = CGRectMake(0, 0, 200, 200);
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
//        _clickBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _clickBtn.layer.borderWidth = 2.f;
//        _clickBtn.layer.cornerRadius = 3.0f;
        [self addSubview:_clickBtn];
        [self addSubview:_imageV];
    }
    return self;
}

-(void)setToRect:(CGRect)toRect{
    
    _toRect = toRect;
}

- (void)newUserGuideWithImage:(UIImage *)image
{
        // 这里添加第二个路径 （这个是圆）
//    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width - 30, 42) radius:30 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    // 这里添加第二个路径 （这个是矩形）
//    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.frame.size.width/2.0-1, 234, self.frame.size.width/2.0+1, 55) cornerRadius:5] bezierPathByReversingPath]];
    
    _clickBtn.frame = _toRect;
//    [_path removeAllPoints];
    UIBezierPath *path = [[UIBezierPath bezierPathWithRoundedRect:_toRect cornerRadius:3] bezierPathByReversingPath];
    
    [_path appendPath:path];
    _shapeLayer.path = _path.CGPath;
//    _shapeLayer.strokeColor = [UIColor blueColor].CGColor;
//    _shapeLayer.lineWidth = 1.f;
    [self.layer setMask:_shapeLayer];
    
    
    _imageV.size = image.size;
    _imageV.centerX = self.centerX;
    _imageV.top = _toRect.origin.y + 50;
    _imageV.image = image;
    
}

-(void)BtnClick{
    if (_nexGuidanceView) {
        _nexGuidanceView(self);
    }
}

@end
