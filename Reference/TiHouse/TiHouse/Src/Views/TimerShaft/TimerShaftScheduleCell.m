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

#import "TimerShaftScheduleCell.h"
#import "NSDate+Common.h"
#import "TweetScheduleMap.h"
#import "UICustomCollectionView.h"
#import "HouerInfoMediaItemCCell.h"
@interface TimerShaftScheduleCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *colorView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *line;//时光轴的线
@property (nonatomic ,retain) UIView *contentsView;
@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (nonatomic ,strong) UILabel *dateView,*titleView ,*scheduleNameView, *scheduleTimeView, *timeView;
@property (nonatomic ,strong) TweetSchedule *tweetSchedule;
@property (nonatomic ,strong) UIButton *scheduletypeBtn;//行程完成状态

@end

@implementation TimerShaftScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineStyle = CellLineStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self topView];
        [self icon];
        [self line];
        [self dateView];
        [self contentsView];
        [self colorView];
        [self titleView];
        [self scheduleNameView];
        [self scheduleTimeView];
        [self mediaView];
        [self timeView];
        [self scheduletypeBtn];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _dateView.hidden = _icon.hidden;
    if (_icon.hidden) {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }else{
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_icon.mas_centerX);
            make.top.equalTo(_icon.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(1));
        }];
    }
    [_line.superview layoutIfNeeded];
}


- (void)setmodelTweetScheduleMap:(TweetScheduleMap *)tweetScheduleMap needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    _tweetScheduleMap = tweetScheduleMap;
    _tweetSchedule = [tweetScheduleMap.schedule transformTweetSchedule];
    
    //日程完成状态
    if (_tweetSchedule.scheduletype) {
        [_scheduletypeBtn setTitle:@"已完成" forState:(UIControlStateNormal)];
    }else{
        [_scheduletypeBtn setTitle:@"未完成" forState:(UIControlStateNormal)];
    }
    
    NSString *tempHex = [NSString stringWithFormat:@"#%@", _tweetSchedule.schedulecolor];
    _colorView.backgroundColor = [self colorWithHexString:tempHex];
    
    _topView.height = needTopView ? 20 : 0;
    _icon.y = CGRectGetMaxY(_topView.frame);
    //行程最后更新时间
    _dateView.text = [[NSDate dateWithTimeIntervalSince1970:_tweetScheduleMap.latesttime/1000] stringDisplay_MMdd];
    _dateView.size = [_dateView sizeThatFits:CGSizeMake(20, 20)];
    _dateView.x = CGRectGetMaxX(_icon.frame)+6;
    _dateView.centerY = _icon.centerY;
    //容器
    _contentsView.y = CGRectGetMaxY(_icon.frame) +11;
    //行程内容
    [_scheduleNameView setLongString:_tweetSchedule.schedulename withFitWidth:_contentsView.width-13 maxHeight:250];;
    _scheduleNameView.y = CGRectGetMaxY(_titleView.frame) + 4;
    //行程时间
    NSDate *tartDate = [NSDate dateWithTimeIntervalSince1970:_tweetSchedule.schedulestarttime/1000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:_tweetSchedule.scheduleendtime/1000];
    _scheduleTimeView.text = [tartDate stringTimeCha:endDate];
    _scheduleTimeView.y = CGRectGetMaxY(_scheduleNameView.frame);
    //提醒头像
    _mediaView.y = CGRectGetMaxY(_scheduleTimeView.frame) + 3;
    NSInteger rowItems = ceilf((float)(kTreetMedia_Wtith-26)/30);
//    _mediaView.height = ceilf((float)_tweetSchedule.urlschedulearruidtipArr.count/rowItems)*(kTreetMedia_Wtith-26-(rowItems-1)*2)/rowItems;
    NSInteger lineCount =ceilf((float)_tweetSchedule.urlschedulearruidtipArr.count/rowItems);
    _mediaView.height =  lineCount * 25 + (lineCount - 1) *kTreetMedia_MediaItem_Pading;
    //发布时间
    _timeView.text = [NSString stringWithFormat:@"%@，%@",_tweetScheduleMap.nickname,[[NSDate dateWithTimeIntervalSince1970:_tweetScheduleMap.latesttime/1000] stringDisplay_HHmm]];
    _timeView.y = CGRectGetMaxY(_mediaView.frame);
    _contentsView.height = CGRectGetMaxY(_timeView.frame);
    
    [_mediaView reloadData];
}


#pragma mark Collection M



+ (CGFloat)cellHeightWithTweetScheduleMap:(TweetScheduleMap *)tweetScheduleMap needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    
    TweetSchedule *tweetSchedule = [tweetScheduleMap.schedule transformTweetSchedule];
    
    CGFloat cellHeight = 0;
    cellHeight += needTopView ? 20 : 0;
    cellHeight += 11.0;//时间轴图标高度
    cellHeight += 9.0;//容器top间距
    cellHeight += 38 + 4;//标题
    cellHeight += [self contentLabelHeight:tweetSchedule.schedulename];
    cellHeight += 20;//行程时间
    NSInteger rowItems = ceilf((float)(kTreetMedia_Wtith-26)/30);
//    cellHeight += ceilf((float)tweetSchedule.urlschedulearruidtipArr.count/rowItems)*(kTreetMedia_Wtith-26-(rowItems-1)*2)/rowItems + 3;//提醒头像高度
    NSInteger lineCount =ceilf((float)tweetSchedule.urlschedulearruidtipArr.count/rowItems);
    cellHeight += lineCount * 25 + (lineCount - 1) *kTreetMedia_MediaItem_Pading + 3;//提醒头像高度
    cellHeight += 43.0f;//日期用户名
    cellHeight += needBottomView ? BOTTOMHEIGHT : 0;
    
    return ceilf(cellHeight);
}

+ (CGFloat)contentLabelHeight:(NSString *)text{
    CGFloat height = 0;
    if (text.length > 0) {
        height += MIN(200, [text getHeightWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(250, CGFLOAT_MAX)]);
    }
    return height;
}


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

-(UIView *)colorView {
    if(!_colorView) {
        _colorView = [[UIView alloc]initWithFrame:CGRectMake(15, 45, 15, 15)];
        _colorView.backgroundColor = XWColorFromHex(0xFCD586);
        [_contentsView addSubview:_colorView];
    }
    return _colorView;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_topView.frame), 11, 11)];
        _icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UILabel *)dateView{
    if (!_dateView) {
        _dateView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
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


-(UIView *)contentsView{
    if (!_contentsView) {
        _contentsView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_line.frame)+11, CGRectGetMaxY(_icon.frame)+9, kTreetMedia_Wtith, 0)];
        _contentsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentsView];
    }
    return _contentsView;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, _contentsView.width-13, 38)];
        _titleView.textColor = XWColorFromHex(0x95989a);
        _titleView.font = [UIFont systemFontOfSize:12];
        _titleView.text = @"添加了一个新日程";
        [_contentsView addSubview:_titleView];
    }
    return _timeView;
}

-(UILabel *)scheduleNameView{
    if (!_scheduleNameView) {
        _scheduleNameView = [[UILabel alloc]initWithFrame:CGRectMake(38, 0, _contentsView.width-13, 38)];
        _scheduleNameView.textColor = [UIColor blackColor];
        _scheduleNameView.font = [UIFont systemFontOfSize:18];
        [_contentsView addSubview:_scheduleNameView];
    }
    return _scheduleNameView;
}

-(UILabel *)scheduleTimeView{
    if (!_scheduleTimeView) {
        _scheduleTimeView = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, _contentsView.width-13, 20)];
        _scheduleTimeView.textColor = XWColorFromHex(0xbfbfbf);
        _scheduleTimeView.font = [UIFont systemFontOfSize:11];
        [_contentsView addSubview:_scheduleTimeView];
    }
    return _scheduleTimeView;
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tweetSchedule.urlschedulearruidtipArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouerInfoMediaItemCCell *curMediaItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem forIndexPath:indexPath];
    curMediaItem.imageV.alpha = 0;
    curMediaItem.imageV.layer.cornerRadius = 25/2;
    [curMediaItem.imageV sd_setImageWithURL:[NSURL URLWithString:_tweetSchedule.urlschedulearruidtipArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.5 animations:^{
            curMediaItem.imageV.alpha = 1.0f;
        }];
    }];
    curMediaItem.vidoImage.hidden = YES;
    
    return curMediaItem;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize = CGSizeMake(25, 25);
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection;
    insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
    return insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return kTreetMedia_MediaItem_Pading;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kTreetMedia_MediaItem_Pading;
}

-(UICustomCollectionView *)mediaView{
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICustomCollectionView alloc]initWithFrame:CGRectMake(13, 0, kTreetMedia_Wtith - 26, 0) collectionViewLayout:layout];
        _mediaView.scrollEnabled = NO;
        [_mediaView setBackgroundColor:[UIColor whiteColor]];
        [_mediaView registerClass:[HouerInfoMediaItemCCell class] forCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem];
        _mediaView.dataSource = self;
        _mediaView.delegate = self;
        [_contentsView addSubview:_mediaView];
    }
    return _mediaView;
}


-(UILabel *)timeView{
    if (!_timeView) {
        _timeView = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, _contentsView.width-13, 41)];
        _timeView.textColor = XWColorFromHex(0xbfbfbf);
        _timeView.font = [UIFont systemFontOfSize:11];
        [_contentsView addSubview:_timeView];
    }
    return _timeView;
}

-(UIButton *)scheduletypeBtn{
    if (!_scheduletypeBtn) {
        _scheduletypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scheduletypeBtn.backgroundColor = kTiMainBgColor;
        _scheduletypeBtn.frame = CGRectMake(kTreetMedia_Wtith - 70, 10, 60, 30);
        _scheduletypeBtn.layer.cornerRadius = 15.0f;
        _scheduletypeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_scheduletypeBtn setTitleColor:XWColorFromHex(0x44444b) forState:UIControlStateNormal];
        [_contentsView addSubview:_scheduletypeBtn];
    }
    return _scheduletypeBtn;
}


-(void)lockBuggetClick:(UIButton *)btn{
    if (self.CellBlockClick) {
        self.CellBlockClick(btn.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
