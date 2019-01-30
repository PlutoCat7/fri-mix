//
//  MineTableFooter.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineTableFooter.h"

@interface MineTableFooter()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MineTableFooter

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        [self.textLabel setText:title];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = ZISIZE(12);
        _textLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kRKBHEIGHT(10)));
            make.left.equalTo(@(kRKBWIDTH(12)));
        }];
    }
    return _textLabel;
}

@end
