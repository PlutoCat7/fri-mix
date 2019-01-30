//
//  ActivityDetailTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ActivityDetailTableViewCell.h"
#import "FSCustomButton.h"

@interface ActivityDetailTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel, *detailLabel, *timeLabel;
@property (nonatomic, strong) UIView *galleryView;
@property (nonatomic, strong) FSCustomButton *thumbUpBtn, *commentBtn, *shareBtn;
@end

@implementation ActivityDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.topLineStyle = CellLineStyleNone;
        self.bottomLineStyle = CellLineStyleNone;
        [self avatarView];
        [self nameLabel];
        [self detailLabel];
        [self timeLabel];
        [self galleryView];
        [self thumbUpBtn];
        [self commentBtn];
        [self shareBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    NSInteger xinset = kRKBWIDTH(15);
    NSInteger yinset = kRKBHEIGHT(5);
    frame.origin.x += xinset;
    frame.origin.y += yinset;
    frame.size.width -= 2 * xinset;
    frame.size.height -= 2 * yinset;
    [super setFrame:frame];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = kRKBWIDTH(20);
        _avatarView.layer.masksToBounds = YES;
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.contentView addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(10));
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(8.5));
            make.size.equalTo(@(kRKBWIDTH(40)));
        }];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = kRKBNAVBLACK;
        _nameLabel.numberOfLines = 1;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(kRKBWIDTH(11.5));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(10));
//            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    _nameLabel.text = @"用户名字";
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = kRKBNAVBLACK;
        _detailLabel.numberOfLines = 1;
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(kRKBWIDTH(4));
//            make.right.equalTo(self.contentView.mas_right).offset(-kRKBWIDTH(20));
            make.top.equalTo(_nameLabel);
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    _detailLabel.text = @"赞了一个";
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = XWColorFromHex(0xBFBFBF);
        _timeLabel.numberOfLines = 1;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(105));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    _timeLabel.text = @"11-20 12:03";
    return _timeLabel;
}

- (UIView *)galleryView {
    if (!_galleryView) {
        _galleryView = [[UIView alloc] init];
        _galleryView.backgroundColor = XWColorFromHex(0x000000);
        [self.contentView addSubview:_galleryView];
//        NSArray *images = @[
//                            @"",
//                            @"",
//                            @"",
//                            ];
//        int index = 0;
//        NSArray *tmpImgv = [NSArray array];
//        for (NSString *str in images) {
//            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//            [imgv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//            imgv.backgroundColor = XWColorFromHex(0xff0000);
//            [_galleryView addSubview:imgv];
//            [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
//                if ([tmpImgv count] == 0) {
//                    make.left.equalTo(_galleryView).offset(10);
//                } else {
//                    make.left.equalTo([tmpImgv objectAtIndex:index - 1]).offset(kRKBWIDTH(110));
//                }
//                make.top.equalTo(_galleryView).offset(kRKBHEIGHT(10));
//                CGFloat width = (kScreen_Width - 80) / 3.0;
//                make.width.equalTo(@(width));
//                make.height.equalTo(@(width));
//            }];
//            [tmpImgv arrayByAddingObject:imgv];
//            index = index + 1;
//        }
        [_galleryView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = (kScreen_Width - 60) / 1.0;
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(10));
            make.top.equalTo(self.timeLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.width.equalTo(@(width));
            make.height.equalTo(@(kRKBHEIGHT(100)));
        }];
    }
    return _galleryView;
}

- (FSCustomButton *)thumbUpBtn {
    if (!_thumbUpBtn) {
        _thumbUpBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_thumbUpBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_thumbUpBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_thumbUpBtn setImage:[UIImage imageNamed:@"notfaved"] forState:UIControlStateNormal];
        _thumbUpBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _thumbUpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _thumbUpBtn.layer.cornerRadius = 5;
        _thumbUpBtn.tag = 1;
        _thumbUpBtn.titleLabel.font = ZISIZE(12);
        [self.contentView addSubview:_thumbUpBtn];
        [_thumbUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = (kScreen_Width - 100) / 3.0;
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(15));
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
    }
    return _thumbUpBtn;
}

- (FSCustomButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        _commentBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _commentBtn.layer.cornerRadius = 5;
        _commentBtn.tag = 2;
        _commentBtn.titleLabel.font = ZISIZE(12);
        [self.contentView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = (kScreen_Width - 100) / 3.0;
            make.left.equalTo(_thumbUpBtn.mas_right).offset(kRKBWIDTH(15));
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
    }
    return _commentBtn;
}

- (FSCustomButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        _shareBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _shareBtn.layer.cornerRadius = 5;
        _shareBtn.tag = 3;
        _shareBtn.titleLabel.font = ZISIZE(12);
        [self.contentView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = (kScreen_Width - 100) / 3.0;
            make.left.equalTo(_commentBtn.mas_right).offset(kRKBWIDTH(15));
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
    }
    return _shareBtn;
}




@end

