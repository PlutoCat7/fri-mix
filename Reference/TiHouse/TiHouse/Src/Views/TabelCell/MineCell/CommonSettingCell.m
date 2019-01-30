//
//  CommonSettingCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonSettingCell.h"
#import "Login.h"

@interface CommonSettingCell()

@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation CommonSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    if (![self.reuseIdentifier isEqualToString:@"quitCellId"]) {
        [self titleLabel];
        [self arrow];
        if ([self.reuseIdentifier isEqualToString:@"wifiCellId"]) {
            [self switchControl];
            [_arrow setHidden:YES];
        } else if ([self.reuseIdentifier isEqualToString:@"cacheCellId"]) {
            [self subLabel];
        }
    } else {
        [self quitButton];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ZISIZE(13);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLabel;
}

- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [[UIButton alloc] init];
        _quitButton.titleLabel.font = ZISIZE(13);
        [self.contentView addSubview:_quitButton];
        [_quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_quitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [_quitButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

- (UISwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [self.contentView addSubview:_switchControl];
        [_switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
        _switchControl.onTintColor = [UIColor colorWithHexString:@"FEC00D"];
    }
    return _switchControl;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        [self.contentView addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
        }];
        _arrow.image = [UIImage imageNamed:@"mine_grayarrow"];
    }
    return _arrow;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(_arrow.mas_left).offset(-10);
        }];
        _subLabel.font = ZISIZE(13);
        _subLabel.textColor = kColor999;
    }
    return _subLabel;
}

#pragma mark - target action
- (void)buttonClick {
    if ([_delegate respondsToSelector:@selector(quitLogin)]) {
        [_delegate quitLogin];
    }
}

- (void)switchAction:(UISwitch *)switchControl {
    if (_switchBlock) {
        _switchBlock(switchControl.isOn);
    }
}

@end
