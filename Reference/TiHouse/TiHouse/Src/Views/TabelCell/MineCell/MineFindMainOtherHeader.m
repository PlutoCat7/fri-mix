//
//  MineFindMainOtherHeader.m
//  TiHouse
//
//  Created by admin on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainOtherHeader.h"
#import "Login.h"
#import "FSCustomButton.h"

@interface MineFindMainOtherHeader()
@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) UILabel *nameLabel, *statsLabel;
@property (nonatomic, retain) FSCustomButton *followBtn, *unfollowBtn;
@end

@implementation MineFindMainOtherHeader

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [[UIImage imageNamed:@"mine_find_bg"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        self.backgroundView = imgV;
        [self avatarView];
        [self nameLabel];
        [self followBtn];
        [self unfollowBtn];
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
            make.height.equalTo(@(20));
            make.top.equalTo(_avatarView.mas_bottom).offset(kRKBHEIGHT(10));
            make.centerX.equalTo(self.contentView);
        }];
    }
    _nameLabel.text = @" ";
    return _nameLabel;
}

-(FSCustomButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[FSCustomButton alloc] init];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        _followBtn.backgroundColor = XWColorFromHex(0xFCEF8C);
        [_followBtn setImage:[UIImage imageNamed:@"add_fav_btn"] forState:UIControlStateNormal];
        _followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _followBtn.layer.cornerRadius = 5;
        _followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.contentView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@110);
            make.height.equalTo(@40);
            make.top.equalTo(_nameLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.centerX.equalTo(self.contentView);
        }];
        [_followBtn addTarget:self action:@selector(addConcern:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

-(FSCustomButton *)unfollowBtn {
    if (!_unfollowBtn) {
        _unfollowBtn = [[FSCustomButton alloc] init];
        _unfollowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_unfollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _unfollowBtn.backgroundColor = XWColorFromHex(0xFAF7F2);
        _unfollowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _unfollowBtn.layer.cornerRadius = 5;
        _unfollowBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.contentView addSubview:_unfollowBtn];
        [_unfollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@110);
            make.height.equalTo(@40);
            make.top.equalTo(_nameLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.centerX.equalTo(self.contentView);
        }];
        [_unfollowBtn addTarget:self action:@selector(removeConcern:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfollowBtn;
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
    if (user.isConcern == 0) {
        [_followBtn setHidden:YES];
    } else {
        [_unfollowBtn setHidden:YES];
    }
    _nameLabel.text = user.username;
    _unfollowBtn.tag = user.uid;
    _followBtn.tag = user.uid;
    [_avatarView sd_setImageWithURL:user.urlhead placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _statsLabel.text = [NSString stringWithFormat:@"关注 %d     粉丝 %d", user.countconcernuid, user.countconcernuidon];
    
}

-(void)addConcern:(UIButton *)btn
{
    User *me = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/add" withParams:@{@"concernuid":[NSString stringWithFormat:@"%ld", me.uid], @"concernuidon": [NSString stringWithFormat:@"%ld", btn.tag]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data) {
            _followBtn.hidden = YES;
            _unfollowBtn.hidden = NO;
            _user.countconcernuidon = _user.countconcernuidon + 1;
            _statsLabel.text = [NSString stringWithFormat:@"关注 %d     粉丝 %d", _user.countconcernuid, _user.countconcernuidon];
            NSLog(@"%@", data);
        } else {
            NSLog(@"%@", error);
        }
    }];
    
}

-(void)removeConcern:(UIButton *)btn
{
    [self showAlerts:^{
        User *me = [Login curLoginUser];
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/remove" withParams:@{@"concernuid":[NSString stringWithFormat:@"%ld", me.uid], @"concernuidon": [NSString stringWithFormat:@"%ld", btn.tag]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if (data) {
                _followBtn.hidden = NO;
                _unfollowBtn.hidden = YES;
                _user.countconcernuidon = _user.countconcernuidon - 1;
                _statsLabel.text = [NSString stringWithFormat:@"关注 %d     粉丝 %d", _user.countconcernuid, _user.countconcernuidon];
                NSLog(@"%@", data);
            } else {
                NSLog(@"%@", error);
            }
        }];
    }];

}

- (void)showAlerts:(void(^)(void))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认不再关注" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion();
    }];
    [clearAction setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancelAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [alertController addAction:clearAction];
    [alertController addAction:cancelAction];
    [self.findViewController presentViewController:alertController animated:YES completion:nil];
}


@end
