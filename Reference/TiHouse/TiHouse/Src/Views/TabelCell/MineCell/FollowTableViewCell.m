//
//  FollowTabeViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#define kFollowCell_DataHight 80
#define kFollowCell_PadingLeft 143.0
#define kFollowCell_AreaPadding 40.0
#define kFollowCellContent_Width kScreen_Width - kFollowCell_PadingLeft*2 - 40
#define kFollowCell_ContentFont [UIFont fontWithName:@"Heiti SC" size:14]
#define kTitleFollowCOLOR XWColorFromHex(0x44444B)
#define kTitleNotFollowCOLOR XWColorFromHex(0xe5e5e5)
#define kBackgroundButtonCOLOR XWColorFromHex(0xFCEF8C)

#import "FollowTableViewCell.h"
#import "FSCustomButton.h"
#import "Login.h"

@interface FollowTableViewCell()

@property (nonatomic, strong) UIImageView *avatarImgv;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *areaIconView;

@end

@implementation FollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

// - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//     [super setSelected:selected animated:animated];
// }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self avatarImgv];
        [self titleLabel];
//        [self areaIconView];
//        [self areaLabel];
        [self followBtn];
        [self followedBtn];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (UIImageView *)avatarImgv {
    if (!_avatarImgv) {
        _avatarImgv = [[UIImageView alloc] init];
        _avatarImgv.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgv.clipsToBounds = YES;
        _avatarImgv.layer.cornerRadius = kRKBWIDTH(25);
        _avatarImgv.layer.masksToBounds = YES;
        [_avatarImgv sd_setImageWithURL:[NSURL URLWithString:_user.urlhead] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.contentView addSubview:_avatarImgv];
        [_avatarImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(15));
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(20));
            make.size.equalTo(@(kRKBWIDTH(50)));
        }];
    }
    return _avatarImgv;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = kRKBNAVBLACK;
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImgv.mas_right).offset(kRKBWIDTH(11.5));
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(105));
            make.top.equalTo(self.contentView).offset(20);
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
        _titleLabel.text = _user.username;
    }
    return _titleLabel;
}

- (UIImageView *) areaIconView {
    if (!_areaIconView) {
        _areaIconView = [[UIImageView alloc] init];
        _areaIconView.contentMode = UIViewContentModeScaleAspectFill;
        _areaIconView.image = [UIImage imageNamed:@"mine_location"];
        [self.contentView addSubview:_areaIconView];
        [_areaIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel).offset(kRKBHEIGHT(20));
        }];
    }
    return _areaIconView;
}


- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.textColor = XWColorFromHex(0xBFBFBF);
        _areaLabel.numberOfLines = 1;
        _areaLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        [self.contentView addSubview:_areaLabel];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel).offset(kRKBWIDTH(20));
            make.right.equalTo(self.titleLabel);
            make.top.equalTo(self.areaIconView);
            make.height.equalTo(@(kRKBHEIGHT(12)));
        }];
        _areaLabel.text = @"";
    }
    return _areaLabel;
}

- (FSCustomButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(100, 220, 200, 40)];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        [_followBtn setTitle:@"➕关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:kTitleFollowCOLOR forState:UIControlStateNormal];
        _followBtn.backgroundColor = kBackgroundButtonCOLOR;
//         [_followBtn setImage:[UIImage imageNamed:@"find_add_attention"] forState:UIControlStateNormal];
//        _followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _followBtn.layer.cornerRadius = 5;
//        _followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_followBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _followBtn.tag = _user.uid;
        [self.contentView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(15));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(23));
            make.width.equalTo(@(kRKBWIDTH(80)));
            make.height.equalTo(@(kRKBHEIGHT(34)));
        }];
        [_followBtn addTarget:self action:@selector(addConcern:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

- (FSCustomButton *)followedBtn {
    if (!_followedBtn) {
        _followedBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(100, 220, 200, 40)];
        _followedBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        [_followedBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followedBtn setTitleColor:kTitleFollowCOLOR forState:UIControlStateNormal];
        [_followedBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _followedBtn.backgroundColor = kTitleNotFollowCOLOR;
//        _followedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _followedBtn.layer.cornerRadius = 5;
        _followedBtn.tag = _user.uid;
        [self.contentView addSubview:_followedBtn];
        [_followedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(15));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(23));
            make.width.equalTo(@(kRKBWIDTH(80)));
            make.height.equalTo(@(kRKBHEIGHT(34)));
        }];
        [_followedBtn addTarget:self action:@selector(cancelConcern:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followedBtn;
}



- (void)hideBtn {
    _followBtn.hidden = YES;
    _followedBtn.hidden = YES;
}

-(void)setUser: (User *)user {
    _user = user;
    _titleLabel.text = user.username;
    _areaLabel.text = @"demo";//user.nickname;
    _followBtn.tag = user.uid;
    _followedBtn.tag = user.uid;
    if (user.isConcern == 0) {
        [_followedBtn setHidden:YES];
    } else {
        [_followBtn setHidden:YES];
    }
    [_avatarImgv sd_setImageWithURL:[NSURL URLWithString:user.urlhead] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

-(void)setIsBtnShow: (BOOL)show {
    [_followBtn setHidden:!show];
    [_followedBtn setHidden:!show];
}

-(void)addConcern:(UIButton *)btn
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/add" withParams:@{@"concernuidon": [NSString stringWithFormat:@"%ld", btn.tag]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            // [weakSelf.tableView reloadData];
            self.followBtn.hidden = YES;
            self.followedBtn.hidden = NO;
        }
        
    }];

}

- (void)cancelConcern:(UIButton *)btn {

    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/remove" withParams:@{@"concernuidon": [NSString stringWithFormat:@"%ld", btn.tag]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            // [weakSelf.tableView reloadData];
            self.followBtn.hidden = NO;
            self.followedBtn.hidden = YES;
        }
    }];
}

@end

