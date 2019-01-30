//
//  HouseTweetTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseTweetTableViewCell.h"
#import "HouseTweet.h"
@interface HouseTweetTableViewCell()

@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *oneImageView;
@property (nonatomic, retain) UIImageView *tweImageView;
@property (nonatomic, retain) UILabel *textLabelV;
@property (nonatomic, retain) UIImageView *iocn;

@end
@implementation HouseTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self dateLabel];
        [self oneImageView];
        [self tweImageView];
        [self textLabelV];
        [self iocn];
        
    }
    return self;
}


-(void)setTweet:(HouseTweet *)tweet{
    
    _tweet = tweet;

    _dateLabel.text = tweet.createData;
    if (tweet.dairydesc.length>0) {
        _textLabelV.text = tweet.dairydesc;
    }
    
    if (_tweet.images.count>=2) {
        [_oneImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(170));
            make.width.equalTo(_tweImageView);
            make.top.equalTo(_dateLabel.mas_bottom);
            make.right.equalTo(_tweImageView.mas_left).offset(-12);
            make.left.equalTo(self.contentView).offset(12);
        }];
        [_tweImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(170));
            make.width.equalTo(_oneImageView);
            make.top.equalTo(_dateLabel.mas_bottom);
            make.left.equalTo(_oneImageView.mas_right).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        
        TweetImage *oneimage = _tweet.images.firstObject;
        TweetImage *twoimage = _tweet.images.lastObject;
        _oneImageView.image = oneimage.image;
        _tweImageView.image = twoimage.image;
    }else{
        [_oneImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(235));
            make.top.equalTo(_dateLabel.mas_bottom);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        [_tweImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        TweetImage *image = _tweet.images.firstObject;
        _oneImageView.image = image.image;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}


-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = kTitleAddHouseTitleCOLOR;
        [self.contentView addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self);
            make.height.equalTo(@(40));
        }];
    }
    return _dateLabel;
}
-(UIImageView *)oneImageView{
    if (!_oneImageView) {
        _oneImageView = [[UIImageView alloc]init];
        _oneImageView.contentMode = UIViewContentModeScaleAspectFill;
        _oneImageView.clipsToBounds = YES;
        [self.contentView addSubview:_oneImageView];
        [_oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateLabel);
            make.top.equalTo(_dateLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return _oneImageView;
}
-(UIImageView *)tweImageView{
    if (!_tweImageView) {
        _tweImageView = [[UIImageView alloc]init];
        _tweImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tweImageView.clipsToBounds = YES;
        [self.contentView addSubview:_tweImageView];
        [_tweImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_dateLabel);
            make.top.equalTo(_dateLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return _tweImageView;
}
-(UILabel *)textLabelV{
    if (!_textLabelV) {
        _textLabelV = [[UILabel alloc]init];
        _textLabelV.textColor = kTitleAddHouseTitleCOLOR;
        _textLabelV.font = [UIFont systemFontOfSize:18];
        _textLabelV.text = @"添加照片说明";
        [self.contentView addSubview:_textLabelV];
        [_textLabelV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_dateLabel);
            make.bottom.equalTo(self);
            make.height.equalTo(@(50));
        }];
    }
    return _textLabelV;
}

-(UIImageView *)iocn{
    if (!_iocn) {
        _iocn = [[UIImageView alloc]init];
        _iocn.contentMode = UIViewContentModeScaleAspectFill;
        _iocn.clipsToBounds = YES;
        _iocn.image = [UIImage imageNamed:@"HoseTweet_ instructions"];
        [self.contentView addSubview:_iocn];
        [_iocn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_textLabelV.mas_centerY);
            make.right.equalTo(_textLabelV);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _iocn;
}

+(CGFloat)getCellHeightWith:(HouseTweet *)tweet{
    
    CGFloat Height = 0;
    Height = 40;
    if (tweet.images.count >= 2) {
        Height += 170;
    }else{
        Height += 235;
    }
    CGFloat TextHeight = [tweet.dairydesc getHeightWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(kScreen_Width-24, 300)];
    Height += TextHeight < 50 ? 50 : TextHeight;
//    Height += 30;
    
    return Height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
