//
//  ProgressView.m
//  TiHouse
//
//  Created by gaodong on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView()

@property (retain, nonatomic) UIView *progressBG;
@property (retain, nonatomic) UIView *progressView;
@property (retain, nonatomic) UIImageView *imgIcon;
@property (retain, nonatomic) UILabel *lblTitle;
@property (retain, nonatomic) UILabel *lblPrice;

@end


@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_imgIcon setImage:[UIImage imageNamed:self.IconName]];
    _lblTitle.text = _Title;
    _lblPrice.text = [NSString stringWithFormat:@"￥%@",_Price];
    
    _progressView.backgroundColor = _isPay? XWColorFromHex(0xfcf7cc):XWColorFromHex(0xe3f5ea);
    [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    
    _lblPrice.textColor = _isPay? XWColorFromHex(0xfec00c):XWColorFromHex(0x11c354);
    
    float progress = _progressBG.frame.size.width * (_Percent/100.00);
    [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(progress);
    }];
}

- (void)addSubviews{

    _progressBG = [[UIView alloc] initWithFrame:CGRectZero];
    [_progressBG setBackgroundColor:XWColorFromHex(0xfbfbfb)];
    _progressBG.layer.cornerRadius = 3.0f;
    _progressBG.clipsToBounds = YES;
    [self addSubview:_progressBG];
    [_progressBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self);
    }];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    [_progressView setBackgroundColor:XWColorFromHex(0xfcf7cc)];
    _progressView.layer.cornerRadius = 3.0f;
    _progressView.clipsToBounds = YES;
    [_progressBG addSubview:_progressView];
    [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressBG);
        make.top.equalTo(_progressBG);
        make.bottom.equalTo(_progressBG);
        make.width.equalTo(@(0));
    }];
    
    _imgIcon = [[UIImageView alloc] init];
    [_progressBG addSubview:_imgIcon];
    [_imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_progressBG);
        make.width.and.height.mas_equalTo(18);
        make.left.mas_equalTo(_progressBG).offset(8);
    }];
    
    _lblTitle = [[UILabel alloc] init];
    [_lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    _lblTitle.textColor = [UIColor darkGrayColor];
    [_progressBG addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_progressBG);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(_imgIcon.mas_right).offset(5);
    }];
    
    _lblPrice = [[UILabel alloc] init];
    [_lblPrice setFont:[UIFont systemFontOfSize:14.0f weight:UIFontWeightBold]];
    [_lblPrice setTextAlignment:NSTextAlignmentRight];
    _lblPrice.textColor = XWColorFromHex(0xfec00c);
    [_progressBG addSubview:_lblPrice];
    [_lblPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_progressBG);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.trailing.mas_equalTo(_progressBG).offset(-15);
    }];
    
}


- (void)updateWithTitle:(NSString *)title Price:(NSInteger)price Percent:(NSInteger)percent isPay:(BOOL)ispay{
    
    self.Title = title;
    self.Price = [NSString stringWithFormat:@"%ld", price];
    self.Percent = percent;
    self.isPay = ispay;
    
    [self layoutSubviews];
}



@end
