//
//  TimerShaftTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#define kTreetCell_LinePadingLeft 18.0
#define kTreetMedia_MediaItem_Pading 5.0
#define kTreetMedia_Wtith kScreen_Width - kTreetCell_LinePadingLeft - 11 - 24
#define  kTreet_ContentFont [UIFont systemFontOfSize:15]
#define BOTTOMHEIGHT 30

#import "TweetMonthCountCell.h"
#import "NSDate+Common.h"
#import "TweetMonthCount.h"
@interface TweetMonthCountCell()

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *line;//时光轴的线
@property (nonatomic ,retain) UIView *contentV;//内容
@property (nonatomic ,strong) UILabel *dateView, *allDataView;

@end

@implementation TweetMonthCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self topView];
        [self icon];
        [self line];
        [self contentV];
        [self allDataView];
        
    }
    return self;
}


#pragma mark Collection M


#pragma mark - getters and setters
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [self.contentView addSubview:_topView];
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_topView.frame), 11, 11)];
        _icon.image = [UIImage imageNamed:@"timerShaft_icon"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}


-(UILabel *)dateView{
    if (!_dateView) {
        _dateView = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateView.textColor = XWColorFromHex(0x44444b);
        _dateView.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateView];
    }
    return _dateView;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(_icon.centerX, CGRectGetMaxY(_icon.frame), 1, self.contentView.height)];
        _line.backgroundColor = kLineColer;
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}


-(UIView *)contentV{
    if (!_contentV) {
        _contentV = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_line.frame) +11,  CGRectGetMaxY(_icon.frame)+9, kTreetMedia_Wtith, (kTreetMedia_Wtith - 34) / 3 + 70)];
        _contentV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentV];
    }
    return _contentV;
}

-(UILabel *)allDataView{
    if (!_allDataView) {
        _allDataView = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, 200, 20)];
        _allDataView.textColor = [UIColor blackColor];
        _allDataView.text = @"224342242条数据";
        _allDataView.font = [UIFont systemFontOfSize:15];
        [_contentV addSubview:_allDataView];
        _contentV.height = [_contentV sizeThatFits:CGSizeMake(20, 20)].height;
    }
    return _allDataView;
}

-(void)setTweetMonthCountS:(TweetMonthCountS *)tweetMonthCountS{
    _tweetMonthCountS = tweetMonthCountS;
    _allDataView.text = [NSString stringWithFormat:@"%ld条记录",_tweetMonthCountS.allCount];
    TweetMonthCount *firstObject = tweetMonthCountS.data.firstObject;
    self.dateView.text = [[NSDate dateWithTimeIntervalSince1970:firstObject.latesttime/1000] stringWithFormat:@"MM月"];;
    _dateView.size = [_dateView sizeThatFits:CGSizeMake(20, 20)];
    _dateView.x = CGRectGetMaxX(_icon.frame)+6;
    _dateView.centerY = _icon.centerY;
    CGFloat itemW = (_contentV.width - 34)/3;
    for (int  i = 0; i < tweetMonthCountS.data.count; i++) {
        TweetMonthCount *item = tweetMonthCountS.data[i];
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(12 + i*(itemW+5), CGRectGetMaxY(_allDataView.frame)+10, itemW, itemW);
        [image sd_setImageWithURL:[NSURL URLWithString:item.urlpic]];
        [_contentV addSubview:image];
    }
}

- (void)setMonthDairyModel:(MonthDairyModel *)monthDairyModel {
    _monthDairyModel = monthDairyModel;
    _allDataView.text = [NSString stringWithFormat:@"%ld条记录",_monthDairyModel.dairymonthnum];
    self.dateView.text = [NSString stringWithFormat:@"%@月",_monthDairyModel.dairymonth];
    _dateView.size = [_dateView sizeThatFits:CGSizeMake(20, 20)];
    _dateView.x = CGRectGetMaxX(_icon.frame)+6;
    _dateView.centerY = _icon.centerY;
    CGFloat itemW = (_contentV.width - 34)/3;
    for (int  i = 0; i < _monthDairyModel.dairymonthfileJA.count; i++) {
        MonthDairyFile *item = _monthDairyModel.dairymonthfileJA[i];
        UIImageView *image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.layer.masksToBounds = YES;
        image.frame = CGRectMake(12 + i*(itemW+5), CGRectGetMaxY(_allDataView.frame)+10, itemW, itemW);
        [image sd_setImageWithURL:[NSURL URLWithString:item.fileurlsmall]];
        [_contentV addSubview:image];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
