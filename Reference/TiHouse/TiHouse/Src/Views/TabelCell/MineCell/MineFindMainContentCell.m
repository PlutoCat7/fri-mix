//
//  MineFindMainContentCell.m
//  TiHouse
//
//  Created by admin on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainContentCell.h"
#import "FSCustomButton.h"
#import "AssemarcModel.h"
#import "NSDate+Extend.h"
#import "FindAssemarcInfo.h"

@interface MineFindMainContentCell ()
@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) UILabel *nameLabel, *timeLabel;
@property (nonatomic, retain) UIButton *actionBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) FSCustomButton *thumbUpBtn, *commentBtn, *shareBtn;

// 图片的描述Label
@property (nonatomic, strong) UILabel *descLabel;
// 文章的标题和描述Label
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *articleLabel;
// 文章的图片
@property (nonatomic, strong) UIImageView *articleImgv;
// 单张图片的Imgv
@property (nonatomic, strong) UIImageView *singleImgv;

// 多图情况下的父View
@property (nonatomic, strong) UIView *photosView;

@end

@implementation MineFindMainContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self avatarView];
        [self nameLabel];
        [self timeLabel];
        [self actionBtn];
        [self line];
        [self thumbUpBtn];
        [self commentBtn];
        [self shareBtn];
        if ([self.reuseIdentifier isEqualToString:@"articleCellId"]) {
            [self articleImgv];
            [self titleLabel];
            [self articleLabel];
        } else {
            [self descLabel];
            if ([self.reuseIdentifier isEqualToString:@"singlePictureCellId"]) {
                [self singleImgv];
            } else {
                [self photosView];
            }
        }
    }
    return self;
}

-(UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        [self.contentView addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kRKBHEIGHT(15)));
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.size.equalTo(@(kRKBHEIGHT(27.5)));
        }];
        _avatarView.layer.cornerRadius = kRKBHEIGHT(13.75);
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(kRKBWIDTH(7));
            make.top.equalTo(@(kRKBHEIGHT(17)));
        }];
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(kRKBHEIGHT(5));
        }];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
    }
    return _timeLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_actionBtn];
        [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(kRKBWIDTH(-12)));
            make.centerY.equalTo(_avatarView);
            make.height.equalTo(@(kRKBHEIGHT(5)));
            make.width.equalTo(@(kRKBWIDTH(20)));
        }];
        [_actionBtn setImage:[UIImage imageNamed:@"mine_edit"] forState:UIControlStateNormal];
    }
    return _actionBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
            make.height.equalTo(@0.5);
            make.top.equalTo(_avatarView.mas_bottom).offset(kRKBHEIGHT(12));
        }];
        _line.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
    }
    return _line;
}

- (FSCustomButton *)thumbUpBtn {
    if (!_thumbUpBtn) {
        _thumbUpBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_thumbUpBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_thumbUpBtn setImage:[UIImage imageNamed:@"notfaved"] forState:UIControlStateNormal];
        [_thumbUpBtn setImage:[UIImage imageNamed:@"faved"] forState:UIControlStateSelected];
        [_thumbUpBtn.titleLabel setFont:ZISIZE(8)];
        _thumbUpBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _thumbUpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _thumbUpBtn.layer.cornerRadius = 5;
        _thumbUpBtn.tag = 1;
        _thumbUpBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_thumbUpBtn];
        [_thumbUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = kRKBWIDTH(50);
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(15));
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
        [_thumbUpBtn addTarget:self action:@selector(thumbUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumbUpBtn;
}

- (FSCustomButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_commentBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:ZISIZE(8)];
        _commentBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _commentBtn.layer.cornerRadius = 5;
        _commentBtn.tag = 2;
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = kRKBWIDTH(50);
            make.left.equalTo(_thumbUpBtn.mas_right).offset(kRKBWIDTH(15));
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
        [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (FSCustomButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_shareBtn setTitleColor:XWColorFromHex(0x999999) forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        _shareBtn.backgroundColor = XWColorFromHex(0xFFFFFF);
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _shareBtn.layer.cornerRadius = 5;
        _shareBtn.tag = 3;
        _shareBtn.titleLabel.font = ZISIZE(12);
        [self.contentView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = kRKBWIDTH(50);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(kRKBHEIGHT(-10));
            make.width.equalTo(@(width));
        }];
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_line);
            make.top.equalTo(_line.mas_bottom).offset(kRKBHEIGHT(15));
            make.width.equalTo(@(kRKBWIDTH(275)));
        }];
        _descLabel.numberOfLines = 0;
        _descLabel.font = ZISIZE(13);
    }
    return _descLabel;
}

- (UIImageView *)singleImgv {
    if (!_singleImgv) {
        _singleImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_singleImgv];
        [_singleImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
            make.top.equalTo(_descLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.height.equalTo(@(kRKBHEIGHT(250)));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick)];
        [_singleImgv addGestureRecognizer:tap];
        _singleImgv.userInteractionEnabled = YES;
    }
    return _singleImgv;
}

- (UIImageView *)articleImgv {
    if (!_articleImgv) {
        _articleImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_articleImgv];
        [_articleImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
            make.top.equalTo(_line.mas_bottom).offset(kRKBHEIGHT(10));
            make.height.equalTo(@(kRKBHEIGHT(175)));
        }];
    }
    return _articleImgv;
}

- (UIView *)photosView {
    if (!_photosView) {
        _photosView = [[UIView alloc] init];
        [self.contentView addSubview:_photosView];
        [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
            make.top.equalTo(_descLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.height.equalTo(@100);
        }];
    }
    return _photosView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = ZISIZE(14);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_articleImgv.mas_bottom).offset(kRKBHEIGHT(10));
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
        }];
    }
    return _titleLabel;
}

- (UILabel *)articleLabel {
    if (!_articleLabel) {
        _articleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_articleLabel];
        _articleLabel.font = ZISIZE(14);
        [_articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(kRKBHEIGHT(10));
            make.left.equalTo(@(kRKBWIDTH(12)));
            make.right.equalTo(@(kRKBWIDTH(-12)));
        }];
        _articleLabel.textColor = [UIColor colorWithHexString:@"dbdbdb"];
    }
    return _articleLabel;
}

- (void)setModel:(FindAssemarcInfo *)model {
    _model = model;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_model.urlhead]];
    _nameLabel.text = _model.username;
    _timeLabel.text = model.createtimeStr;
    [_commentBtn setTitle:[NSString stringWithFormat:@"%d", _model.assemarcnumcomm] forState:UIControlStateNormal];
    [_thumbUpBtn setTitle:[NSString stringWithFormat:@"%d", _model.assemarcnumzan] forState:UIControlStateNormal];

    if (_model.assemarctype == 2) {
        _descLabel.text = model.assemarctitle;
        NSArray *imagesURLArray = [model.urlsoulfilearr componentsSeparatedByString:@","];
        NSInteger count = [imagesURLArray count];
        if (count > 1) {
            for (UIImageView *imgv in _photosView.subviews) {
                [imgv removeFromSuperview];
            }
            [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(kRKBHEIGHT((ceil(count / 3.0))  * 115) + 3 * (ceil(count / 3.0) - 1)));
            }];
            for (NSInteger i = 0; i < count; i++) {
                UIImageView *imgv = [[UIImageView alloc] init];
                [_photosView addSubview:imgv];
                [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(@(kRKBHEIGHT(115)));
                    make.top.equalTo(@(kRKBHEIGHT(115 + 3) * (i / 3)));
                    make.left.equalTo(@(kRKBHEIGHT(115 + 3) * (i % 3)));
                }];
                [imgv sd_setImageWithURL:imagesURLArray[i]];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(multiClick:)];
                imgv.tag = i;
                imgv.userInteractionEnabled = YES;
                [imgv addGestureRecognizer:tap];
            }
        } else {
            
            NSString *assemTitle = [NSString stringWithFormat:@"#%@#", _model.assemtitle];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", _model.assemtitle, assemTitle]];
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRGBHex:0xFEC00C]
                                     range:[[attributedString string] rangeOfString:assemTitle]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kRKBWIDTH(13)] range:NSMakeRange(0, [attributedString string].length)];
            _descLabel.attributedText = [attributedString copy];
            
            
//            _descLabel.text = [NSString stringWithFormat:@"%@#%@#", model.assemarctitle, model.assemtitle];
            [_singleImgv sd_setImageWithURL:[NSURL URLWithString:model.urlsoulfilearr]];
        }
    } else {
        [_articleImgv sd_setImageWithURL:[NSURL URLWithString:_model.urlindex]];
        _titleLabel.text = _model.assemarctitle;
        _articleLabel.text = _model.assemarctitlesub;
    }
}

- (void)share {
    if ([_delegate respondsToSelector:@selector(mineFindCellShare:)]) {
        [_delegate mineFindCellShare:self];
    }
}

- (void)singleClick {
    if ([_delegate respondsToSelector:@selector(mineFineCellSingleImage:imageIndex:)]) {
        [_delegate mineFineCellSingleImage:self imageIndex:0];
    }
}

- (void)multiClick:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(mineFineCellSingleImage:imageIndex:)]) {
        [_delegate mineFineCellSingleImage:self imageIndex:tap.view.tag];
    }
}

- (void)comment {
    if ([_delegate respondsToSelector:@selector(mineFindCellComment:)]) {
        [_delegate mineFindCellComment:self];
    }
}

- (void)thumbUp {
    if ([_delegate respondsToSelector:@selector(mineFindCellStar:)]) {
        [_delegate mineFindCellStar:self];
    }
}
@end
