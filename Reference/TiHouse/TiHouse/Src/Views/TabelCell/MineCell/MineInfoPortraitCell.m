//
//  MineInfoPortraitCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineInfoPortraitCell.h"
#import "Login.h"

@interface MineInfoPortraitCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *portraitImgv;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation MineInfoPortraitCell

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
        [self portraitImgv];
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
        _titleLabel.text = @"头像";
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

- (UIImageView *)portraitImgv {
    if (!_portraitImgv) {
        _portraitImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_portraitImgv];
        _portraitImgv.layer.cornerRadius = 22.5;
        _portraitImgv.layer.masksToBounds = YES;
        [_portraitImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(_arrow.mas_left).offset(-10);
            make.size.equalTo(@(45));
        }];
        [_portraitImgv sd_setImageWithURL:[NSURL URLWithString:[[Login curLoginUser] urlhead]]];
    }
    return _portraitImgv;
}



- (void)reloadImageWithImageUrl:(NSString *)imageUrl {
    [_portraitImgv sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
