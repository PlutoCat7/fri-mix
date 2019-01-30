//
//  ActivityTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "Login.h"

@interface ActivityTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *picView;
//@property (nonatomic, strong) UIImageView *flagView;
@property (nonatomic, strong) UIImageView *videoIconView;

@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.topLineStyle = CellLineStyleNone;
        self.bottomLineStyle = CellLineStyleNone;
        [self avatarView];
        [self nameLabel];
//        [self iconView];
        [self detailLabel];
        [self timeLabel];
        [self picView];
//        [self flagView];
        [self videoIconView];
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

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        _iconView.layer.masksToBounds = YES;
        if ([_activity[@"logdairyopetype"] intValue] == 1) {
            _iconView.image = [UIImage imageNamed:@"star"];
        } else if ([_activity[@"logdairyopetype"] intValue] == 2) {
            _iconView.image = [UIImage imageNamed:@"comment"];
        } else {
            _iconView.image = [UIImage imageNamed:@"star"];
        }
        
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel).offset(kRKBHEIGHT(20));
            make.left.equalTo(_nameLabel);
            make.size.equalTo(@(kRKBWIDTH(12)));
        }];
        
    }
    
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = kRKBNAVBLACK;
        _nameLabel.numberOfLines = 1;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(kRKBWIDTH(11.5));
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(105));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(10));
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    _nameLabel.text = _activity[@""];
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = kRKBNAVBLACK;
        _detailLabel.numberOfLines = 1;
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(kRKBWIDTH(11.5));
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(105));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    _detailLabel.text = @"赞了一个";
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = XWColorFromHex(0xBFBFBF);
        _timeLabel.numberOfLines = 1;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarView.mas_right).offset(kRKBWIDTH(11.5));
            make.right.equalTo(self.contentView).offset(-kRKBWIDTH(105));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(50));
            make.height.equalTo(@(kRKBHEIGHT(14)));
        }];
    }
    return _timeLabel;
}

- (UIImageView *)picView {
    if (!_picView) {
        _picView = [[UIImageView alloc] init];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
        _picView.layer.masksToBounds = YES;
        [_picView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.contentView addSubview:_picView];
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(kRKBWIDTH(-10));
            make.size.equalTo(@(60));
        }];
    }
    return _picView;
}

- (UIImageView *)videoIconView {
    if (!_videoIconView) {
        _videoIconView = [[UIImageView alloc] init];
        _videoIconView.contentMode = UIViewContentModeScaleAspectFill;
        _videoIconView.clipsToBounds = YES;
        _videoIconView.layer.masksToBounds = YES;
//        [_picView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.contentView addSubview:_videoIconView];
        [_videoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_picView);
            make.size.equalTo(@(25));
        }];
    }
    return _videoIconView;
}


//- (UIImageView *)flagView {
//    if (!_flagView) {
//        _flagView = [[UIImageView alloc] init];
//        _flagView.contentMode = UIViewContentModeScaleAspectFill;
//        _flagView.clipsToBounds = YES;
//        _flagView.layer.masksToBounds = YES;
//        _flagView.image = [UIImage imageNamed:@"flag"];
//        [self.contentView addSubview:_flagView];
//        [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView);
//            make.right.equalTo(self.contentView);
//            make.size.equalTo(@(kRKBWIDTH(6)));
//        }];
//    }
//    return _flagView;
//}

- (NSString *)timestampToString:(long)timeStamp {
    NSTimeInterval timeInterval = timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"HH:mm"];
    NSString *hoursandSec = [fo stringFromDate:date];
    
    NSString *createDate = [format stringFromDate:date];
    
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    
    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"%@",hoursandSec];
    } else if ([createDate isEqualToString:yesterday]) {
        return [NSString stringWithFormat:@"昨天"];
    } else {
        return [NSString stringWithFormat:@"%@",createDate];
    }
}

-(void)setAssemarc:(AssemarcModel *)assemarc {
    [_avatarView sd_setImageWithURL:assemarc.urlhead placeholderImage:[UIImage imageNamed:@"placehoder"]];
    NSString *how = @"";
    NSString *what = @"";
    switch (assemarc.assemarctype) {
        case 1:
            what = @"的文章";
            break;
        case 2:
            what = @"的照片";
            break;
        default:
            what = @"";
            break;
    }

    switch (assemarc.logassemarcopetype) {
        case 1:
            _iconView.image = [UIImage imageNamed:@"faved"];
            how = @"赞了";
            _detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@", how, assemarc.usernameon, what];
            break;
        case 2:
            _iconView.image = [UIImage imageNamed:@"comment"];
            how = @"评论了";
            _detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@", how, assemarc.usernameon, what];
            break;
        case 3:
            how = @"收藏了";
            _detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@", how, assemarc.usernameon, what];
            break;
        case 4:
            _detailLabel.text = @"关注了我";
            break;
        case 5:
            _detailLabel.text = @"有了新发现";
            break;
        default:
            how = @"";
            break;
    }
    
    _nameLabel.text = assemarc.username;
    _timeLabel.text = [self timestampToString:assemarc.updatetime];
    [_picView sd_setImageWithURL:[NSURL URLWithString:[[[NSString stringWithFormat:@"%@", assemarc.urlindex] componentsSeparatedByString:@","] objectAtIndex:0]]];
}

-(void)setActivity:(NSMutableDictionary *)activity {
    User *user = [Login curLoginUser];
    if (activity[@"logdairyopetype"]) {
        [_avatarView sd_setImageWithURL:activity[@"urlhead"] placeholderImage:[UIImage imageNamed:@"placehoder"]];
        switch ([activity[@"logdairyopetype"] intValue]) {
            case 1:
                if (YES) {
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.image = [UIImage imageNamed:@"faved"];
                    attch.bounds = CGRectMake(0, 0, 12, 12);
                    NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attch];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@" 赞了一个！"];
                    [str insertAttributedString:iconStr atIndex:0];
                    _detailLabel.attributedText = str;
                }
                break;
            case 2:
                if (YES) {
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.image = [UIImage imageNamed:@"commented"];
                    attch.bounds = CGRectMake(0, 0, 12, 12);
                    NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attch];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", activity[@"logdairyopecontent"]]];
                    [str insertAttributedString:iconStr atIndex:0];
                    _detailLabel.attributedText = str;
                }
                break;
            case 3:
                if ([activity[@"arruidremind"] rangeOfString:[NSString stringWithFormat:@",%@,", @(user.uid)]].location == NSNotFound) {
                    _detailLabel.text = @"发布了日记";
                } else {
                    _detailLabel.text = @"【提醒我看】发布了日记";
                }
                break;
            case 4:
                if ([activity[@"arruidremind"] rangeOfString:[NSString stringWithFormat:@",%@,", @(user.uid)]].location == NSNotFound) {
                    _detailLabel.text = [NSString stringWithFormat:@"%@ 发布了照片", activity[@"logdairyopenickname"]];
                } else {
                    _detailLabel.text = @"【提醒我看】发布了照片";
                }
                break;
            case 5:
                if ([activity[@"arruidremind"] rangeOfString:[NSString stringWithFormat:@",%@,", @(user.uid)]].location == NSNotFound) {
                    _detailLabel.text = @"发布了视频";
                } else {
                    _detailLabel.text = @"【提醒我看】发布了视频";
                }
                break;
            case 6:
                _detailLabel.text = [NSString stringWithFormat:@"关注了%@", activity[@"housename"]];
                break;
            default:
                break;
        }
        _nameLabel.text = activity[@"logdairyopenickname"];
        _timeLabel.text = [self timestampToString:[activity[@"logdairyopectime"] longValue]];
        [_picView sd_setImageWithURL:[NSURL URLWithString:[[activity[@"urlfilesmall"] componentsSeparatedByString:@","] objectAtIndex:0]]];
        self.videoIconView.image = [UIImage imageNamed:[activity[@"logdairyopetype"] intValue] == 5 ? @"video_icon" : @""];

    } else {

    }
    
}

@end

