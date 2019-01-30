//
//  FeedBackTextView.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FeedBackTextView.h"

@interface FeedBackTextView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) NSInteger maxNum;

@end

@implementation FeedBackTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentNum = 0;
        _maxNum = 400;
        [self textView];
        [self label];
    }
    return self;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(@10);
        }];
        _textView.font = ZISIZE(14);
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请简要描述您的问题或意见";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        placeHolderLabel.font = ZISIZE(14);
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.bottom.equalTo(self).offset(-5);
        }];
        _label.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentNum,(long)_maxNum];
        _label.font = ZISIZE(13);
        _label.textColor = [UIColor colorWithHexString:@"bfbfbf"];
    }
    return _label;
}

- (void)reloadCurrentNum:(NSInteger)num {
    _currentNum = num;
    _label.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentNum,(long)_maxNum];
}

@end
