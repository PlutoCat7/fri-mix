//
//  MineInfoNicknameCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineInfoNicknameCell.h"
#import "Login.h"

@interface MineInfoNicknameCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation MineInfoNicknameCell

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
        [self titleLabel];
        [self arrow];
        [self subLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.centerY.equalTo(self.contentView);
        }];
        _titleLabel.text = @"昵称";
        _titleLabel.font = ZISIZE(13);

    }
    return _titleLabel;
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
            make.right.equalTo(_arrow.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        _subLabel.textColor = kColor999;
        _subLabel.text = [[Login curLoginUser] username];
        _subLabel.font = ZISIZE(13);
    }
    return _subLabel;
}

- (void)reloadUsernameWithName:(NSString *)name {
    _subLabel.text = name;
}

@end
