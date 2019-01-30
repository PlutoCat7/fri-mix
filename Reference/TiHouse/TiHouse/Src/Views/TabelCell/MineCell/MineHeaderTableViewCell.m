//
//  MineHeaderTableViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineHeaderTableViewCell.h"
#import "Login.h"

@interface MineHeaderTableViewCell()

@property (nonatomic, strong) UIImageView *portraitImgv;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation MineHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self portraitImgv];
        [self nameLabel];
        [self arrow];
    }
    return self;
}

- (UIImageView *)portraitImgv {
    if (!_portraitImgv) {
        _portraitImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_portraitImgv];
        [_portraitImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(18));
            make.centerY.equalTo(self.contentView);
            make.size.equalTo(@(kRKBHEIGHT(56)));
        }];
        _portraitImgv.layer.cornerRadius = kRKBHEIGHT(28);
        _portraitImgv.layer.masksToBounds = YES;
        [_portraitImgv sd_setImageWithURL:[NSURL URLWithString:[[Login curLoginUser] urlhead]]];
    }
    return _portraitImgv;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_portraitImgv.mas_right).offset(10);
        }];
        _nameLabel.font = ZISIZE(16);
        _nameLabel.text = [[Login curLoginUser] username];
        _nameLabel.textColor = [UIColor colorWithHexString:@"606060"];
    }
    return _nameLabel;
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
        _arrow.image = [UIImage imageNamed:@"mine_blackarrow"];
    }
    return _arrow;
}

- (void)reloadUsername {
    _nameLabel.text = [[Login curLoginUser] username];
}

- (void)reloadImage {
    [_portraitImgv sd_setImageWithURL:[NSURL URLWithString:[[Login curLoginUser] urlhead]]];
}

@end
