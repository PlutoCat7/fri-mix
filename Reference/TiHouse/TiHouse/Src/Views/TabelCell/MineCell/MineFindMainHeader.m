//
//  MineFindMainHeaderCell.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainHeader.h"
#import "FSCustomButton.h"
#import "Login.h"
#import "User.h"

@interface MineFindMainHeader ()
@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) UILabel *nameLabel, *statsLabel;
@property (nonatomic, retain) FSCustomButton *followBtn, *unfollowBtn, *editProfile;
@end

@implementation MineFindMainHeader

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"mine_find_bg"];
        self.backgroundView = imgV;
        [self avatarView];
        [self nameLabel];
        [self editProfile];
        [self statsLabel];
    }
    return self;
}

-(UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.image = [UIImage imageNamed:@"placeholderImage"];
        [self.contentView addSubview:_avatarView];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 30;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.borderWidth = 2.5f;
        _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(45));
        }];
    }
    return _avatarView;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = ZISIZE(14);
        _nameLabel.textColor = kColorWhite;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarView.mas_bottom).offset(kRKBHEIGHT(10));
            make.height.equalTo(@(20));
            make.centerX.equalTo(self.contentView);
        }];
    }
    _nameLabel.text = @" ";
    return _nameLabel;
}

-(FSCustomButton *)editProfile {
    if (!_editProfile) {
        _editProfile = [[FSCustomButton alloc] init];
        _editProfile.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editProfile setTitle:@"编辑资料" forState:UIControlStateNormal];
        _editProfile.backgroundColor = XWColorFromHex(0xFAF7F2);
        [_editProfile setImage:[UIImage imageNamed:@"edit_profile"] forState:UIControlStateNormal];
        _editProfile.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _editProfile.layer.cornerRadius = 5;
        _editProfile.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.contentView addSubview:_editProfile];
        [_editProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@110); 
            make.height.equalTo(@40);
            make.top.equalTo(_nameLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _editProfile;
}

-(UILabel *)statsLabel {
    if (!_statsLabel) {
        _statsLabel = [[UILabel alloc] init];
        _statsLabel.font = ZISIZE(11.5);
        _statsLabel.textColor = kColorWhite;
        [self.contentView addSubview:_statsLabel];
        [_statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-15));
            make.centerX.equalTo(self.contentView);
        }];
    }
    _statsLabel.text = @"关注 0     粉丝 0";
    return _statsLabel;
}

-(void)setUser:(User *)user {
    _user = user;
    _nameLabel.text = user.username;
    [_avatarView sd_setImageWithURL:user.urlhead placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _statsLabel.text = [NSString stringWithFormat:@"关注 %d     粉丝 %d", user.countconcernuid, user.countconcernuidon];
}

@end

