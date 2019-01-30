//
//  AllPictureView.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AllPictureView.h"

@interface AllPictureView()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation AllPictureView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    [self countLabel];
//    [self addButton];
    [self cancelButton];
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [self addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self);
        }];
        _countLabel.textColor = kColorNavTitle;
        _countLabel.font = ZISIZE(12);
        _countLabel.text = @"已选择0张图片";
    }
    return _countLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [self addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = ZISIZE(12);
        _cancelButton.layer.cornerRadius = 4;
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@80);
            make.height.equalTo(@40);
        }];
        _cancelButton.backgroundColor = [UIColor colorWithHexString:@"44444B"];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [self addSubview:_addButton];
        [_addButton setTitle:@"添加到灵感册" forState:UIControlStateNormal];
        [_addButton setTitleColor:kColorNavTitle forState:UIControlStateNormal];
        _addButton.titleLabel.font = ZISIZE(12);
        _addButton.layer.cornerRadius = 4;
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(self);
            make.width.equalTo(@120);
            make.height.equalTo(@40);
        }];
        _addButton.backgroundColor = kTiMainBgColor;
        [_addButton addTarget:self action:@selector(showAddList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - Target Action
- (void)cancel {
    if ([_delegate respondsToSelector:@selector(cancelCollection)]) {
        [_delegate cancelCollection];
    }
}

- (void)showAddList {
    if ([_delegate respondsToSelector:@selector(AddToSoulFolder)]) {
        [_delegate AddToSoulFolder];
    }
}

- (void)reloadSelectedPictures:(NSInteger)count {
    _countLabel.text =  [NSString stringWithFormat:@"已选择%ld张图片", count];
}

@end
