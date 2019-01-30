//
//  HomeEmptyView.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/3/13.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HomeEmptyView.h"

@interface HomeEmptyView()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation HomeEmptyView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self textLabel];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(163.5);
            make.centerX.equalTo(self);
        }];
        _textLabel.text = @"现在就开始添加房屋\n或输入邀请码关注别人的房屋吧";
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}
@end

