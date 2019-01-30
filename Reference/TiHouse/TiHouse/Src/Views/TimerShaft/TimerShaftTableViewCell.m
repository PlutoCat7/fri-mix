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
#define  kTreet_ContentFont [UIFont systemFontOfSize:16]
#define BOTTOMHEIGHT 30
#define FullTextButtonHeight 20

#define kHeightFourLine 78

#import "TimerShaftTableViewCell.h"
#import "UICustomCollectionView.h"
#import "HouerInfoMediaItemCCell.h"
#import "NSDate+Common.h"
#import "CommentPopView.h"
#import "commentTabbleCell.h"
#import "Login.h"
#import "HouseTweet.h"
#import "SharePopView.h"
#import "HouseInfoViewController.h"
#import "SHValue.h"
#import "UMShareManager.h"

@interface TimerShaftTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *line;//时光轴的线
@property (nonatomic ,retain) UIView *contentsView;//发布文字跟时间的容器
@property (nonatomic ,strong) UILabel *dateView ,*nameView, *timeView ,*tweetContent;
@property (nonatomic ,retain) UIView *zanView;//赞View
@property (nonatomic ,strong) UILabel *zanLabel;//赞
@property (nonatomic ,strong) UIImageView *zanIcon;//赞icon
@property (nonatomic ,retain) UIView *commentView;//评论View
@property (nonatomic ,strong) UIImageView *commentIcon;//评论icon
@property (nonatomic ,strong) UITableView *commentTabble;//评论tabble
@property (nonatomic ,strong) UILabel *meTalk;//我也说两句
@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, retain) CAReplicatorLayer *replicatorLayer_Circle;

@property (nonatomic, strong) UIButton *fullTextButton; // 是否显示全文

@property (nonatomic, strong) Dairy *dairy;

// 文本仅自己可见
@property (nonatomic, strong) UIImageView *cornerClockImageView;

@end

@implementation TimerShaftTableViewCell

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
        [self dateView];
        [self line];
        [self mediaView];
        [self contentsView];
        [self zanView];
        [self zanIcon];
        [self zanLabel];
        
        
        [self commentView];
        [self commentIcon];
        [self commentTabble];
        [self meTalk];
        [self cornerClockImageView];        
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


- (void)setmodelDairy:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    
    _modelDairy = modelDairy;
    if (modelDairy.dairy.dairyid) {
        _dairy = [_modelDairy.dairy transformDairy];
    }else{
        _dairy = _modelDairy.dairy;
    }
    
    if (_dairy.dairytype == 1) { // 仅仅只有文本时的锁
        if (_dairy.dairyrangetype && _dairy.dairyrangetype != 3) {
            self.cornerClockImageView.hidden = NO;
        } else {
            self.cornerClockImageView.hidden = YES;
        }
    } else {
        self.cornerClockImageView.hidden = YES;
    }
    
    _topView.height = needTopView ? 20 : 0;
    _icon.y = CGRectGetMaxY(_topView.frame);
    _dateView.text = [[NSDate dateWithTimeIntervalSince1970:_dairy.dairytime/1000] stringDisplay_MMdd];
    _dateView.size = [_dateView sizeThatFits:CGSizeMake(20, 20)];
    _dateView.x = CGRectGetMaxX(_icon.frame)+6;
    _dateView.centerY = _icon.centerY;
    
    if (_dairy.dairytype == 1) {
        _mediaView.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+6, CGRectGetMaxY(_dateView.frame)+8, 0, 0);
        if (_dairy.fileJA.count > 0) {
            if ([_dairy.fileJA[0] isKindOfClass:[TweetImage class]]) {
                _mediaView.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+6, CGRectGetMaxY(_dateView.frame)+8, kTreetMedia_Wtith,
                                              [self mediaViewHeight:_dairy]
                                              );
            }
        }
    }else{
        _mediaView.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+6, CGRectGetMaxY(_dateView.frame)+8, kTreetMedia_Wtith,
                                      [self mediaViewHeight:_dairy]
                                      );
    }
    //Tweet内容
    if (!_modelDairy.dairy.isFullText) {
        [self.tweetContent setLongString:[_dairy.dairydesc stringByRemovingPercentEncoding] withFitWidth:_contentsView.width - 24 maxHeight: kHeightFourLine];
    } else {
        [self.tweetContent setLongString:[_dairy.dairydesc stringByRemovingPercentEncoding] withFitWidth:_contentsView.width - 24 maxHeight:[_modelDairy.dairy.dairydesc getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 24, CGFLOAT_MAX)]];
        
    }
    //用户名及发布时间
    NSString *timeViewStr = _dairy.createtime ? [NSString stringWithFormat:@"%@，%@",_modelDairy.nickname,[[NSDate dateWithTimeIntervalSince1970:_dairy.createtime/1000] stringDisplay_HHmm]] : @"";
    self.timeView.text = timeViewStr;
    
    self.fullTextButton.selected = _modelDairy.dairy.isFullText;
    CGFloat contentH = [[_modelDairy.dairy.dairydesc stringByRemovingPercentEncoding] getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 24, CGFLOAT_MAX)];
    if (kHeightFourLine < contentH) {
        _contentsView.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+6, CGRectGetMaxY(_mediaView.frame), kTreetMedia_Wtith, CGRectGetMaxY(_tweetContent.frame)+34 + FullTextButtonHeight);
        _timeView.y = CGRectGetMaxY(_tweetContent.frame) + FullTextButtonHeight;
        self.fullTextButton.y =  CGRectGetMaxY(_tweetContent.frame);
        self.fullTextButton.height = FullTextButtonHeight;
        self.fullTextButton.hidden = NO;
        
    } else {
        _contentsView.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+6, CGRectGetMaxY(_mediaView.frame), kTreetMedia_Wtith, CGRectGetMaxY(_tweetContent.frame)+34);
        _timeView.y = CGRectGetMaxY(_tweetContent.frame);
        self.fullTextButton.hidden = YES;
    }
    
    self.commentBtn.centerY = _timeView.centerY;
    
    //赞
    if (_modelDairy.listModelDairyzan.count > 0) {
        _zanView.y = CGRectGetMaxY(_contentsView.frame);
        __block NSString *zanla;
        [_modelDairy.listModelDairyzan enumerateObjectsUsingBlock:^(Dairyzan *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                zanla = [obj.username stringByRemovingPercentEncoding];
            }else{
                zanla = [NSString stringWithFormat:@"%@,%@",zanla,[obj.username stringByRemovingPercentEncoding]];
            }
        }];
        _zanLabel.text = zanla;
        [_zanLabel setLongString:zanla withFitWidth:_contentsView.width-63 maxHeight:250];
        _zanIcon.x = 9;
        _zanIcon.y = 13;
//        _zanLabel.centerY = _zanIcon.centerY;
        _zanLabel.x = CGRectGetMaxX(_icon.frame);
        _zanLabel.y = 10;
        _zanView.frame = CGRectMake(_contentsView.x, CGRectGetMaxY(_contentsView.frame), _contentsView.width, CGRectGetMaxY(_zanLabel.frame) + 10);
        
    }else if(modelDairy.listModelDairycomm.count > 0){
        _zanView.frame = CGRectMake(_contentsView.x, CGRectGetMaxY(_contentsView.frame), _contentsView.width, 12);
        _zanView.height = 12;
    }else{
        _zanView.height = 0;
    }
    
    //    _line.height = CGRectGetMaxY(_contentsView.frame) - _line.y;
    
    //评论
    if (_modelDairy.listModelDairycomm.count>0) {
        _commentView.x = _mediaView.x;
        _commentView.y = CGRectGetMaxY(_zanView.frame);
        _commentTabble.height = [TimerShaftTableViewCell commentListViewHeightWithmodelDairy:_modelDairy];
        //我也说两句
        _meTalk.x = 9;
        _meTalk.y = CGRectGetMaxY(_commentTabble.frame) + 11;
        _commentView.height = CGRectGetMaxY(_meTalk.frame)+15;
    }else{
        _commentView.height  = 0;
    }
    
    
    _bottomView.height = needTopView ? BOTTOMHEIGHT : 0;
    _bottomView.y = CGRectGetMaxY(_commentView.frame);
    
    [_mediaView reloadData];
    [_commentTabble reloadData];
    
}


#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(self.dairy.fileJA.count, 9);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouerInfoMediaItemCCell *curMediaItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem forIndexPath:indexPath];
    
    curMediaItem.imageV.alpha = 0;
    
    NSString *url = ((FileModel *)[SHValue value:self.dairy.fileJA][indexPath.row].value).fileurlsmall;
    url = [SHValue value:url].stringValue;
    
    if (self.dairy.dairyid) {
        
//        self.dairy.dairytype == 2 ? [self.dairy.fileJA[indexPath.row] fileurl] : _dairy.urlfilesmallArr[indexPath.row];
        [curMediaItem.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:.5 animations:^{
                curMediaItem.imageV.alpha = 1.0f;
            }];

//            if (self.dairy.arrurlfileArr.count > 9 && indexPath.row == 8) {
//                for (int i = 9; i < self.dairy.fileJA.count; i++) {
//
//                    NSString *url = ((FileModel *)[SHValue value:self.dairy.fileJA][i].value).fileurl;
//
//                    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:1 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//
//                    }];
//                }
//            }
        }];
    } else { // 用于发布状态后本地生成对象
        
        curMediaItem.imageV.alpha = 1.0f;
        if (self.dairy.dairytype == 3) { // 视频
            TweetImage *imagemodel =  self.dairy.urlfilesmallArr[indexPath.row];
            curMediaItem.imageV.image = imagemodel.image;
        }else { //
            TweetImage *imagemodel =  _dairy.arrurlfileArr[indexPath.row];
            curMediaItem.imageV.image = imagemodel.image;
        }
//        TweetImage *imagemodel = self.dairy.arrurlfileArr[indexPath.row];
    }

    //视频
    curMediaItem.vidoImage.hidden = YES;
    if (_dairy.dairytype == 3) {
        curMediaItem.vidoImage.hidden = NO;
    }
    //超过几张图被隐藏
    if (indexPath.row == 8 && _dairy.fileJA.count > 9) {
        curMediaItem.shade.hidden = NO;
        [curMediaItem.UnImaCount setTitle:[NSString stringWithFormat:@"+%ld",_dairy.fileJA.count-9] forState:UIControlStateNormal];
    }else{
        curMediaItem.shade.hidden = YES;
    }
    //仅自己可见
    if (_dairy.dairyrangetype != 3) {
        if (_dairy.fileJA.count >= 3 && indexPath.row == 2) {
            curMediaItem.cornerClock.hidden = NO;
        }else if(_dairy.fileJA.count < 3 && _dairy.fileJA.count-1 == indexPath.row ){
            curMediaItem.cornerClock.hidden = NO;
        }else{
            curMediaItem.cornerClock.hidden = YES;;
        }
    }else{
        curMediaItem.cornerClock.hidden = YES;;
    }
    
    return curMediaItem;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize;
    
    if (self.dairy.fileJA.count == 1) {
        
        CGFloat wh =  self.modelDairy.dairy.fileJA.firstObject.filepercentwh;
        CGFloat height;
        if (wh > 1) {
            // 单张横图
            height = (kTreetMedia_Wtith) / wh;
        } else if (wh == 1) {
            height =  kTreetMedia_Wtith;
        } else {
            height = kTreetMedia_Wtith;
        }

        itemSize = CGSizeMake(kTreetMedia_Wtith, height);
    }else if (_dairy.fileJA.count == 2){
        itemSize = CGSizeMake((kTreetMedia_Wtith - kTreetMedia_MediaItem_Pading)/2.0, (kTreetMedia_Wtith - kTreetMedia_MediaItem_Pading)/2.0);
    }else{
        itemSize = CGSizeMake((kTreetMedia_Wtith-kTreetMedia_MediaItem_Pading*2)/3.0, (kTreetMedia_Wtith-kTreetMedia_MediaItem_Pading*2)/3.0);
    }
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    if (_dairy.dairytype == 3) {
        photoBrowser.isVideo = YES;
    }
    photoBrowser.delegate = self;
    photoBrowser.browserType = PhotoBrowserTyoeTyoeTimerShaft;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.dairy.fileJA.count;
    photoBrowser.sourceImagesContainerView = _mediaView;
    photoBrowser.dairy = _dairy;
    [photoBrowser show];
}


#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    HouerInfoMediaItemCCell *curMediaItem = (HouerInfoMediaItemCCell *)[_mediaView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return curMediaItem.imageV.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (!self.dairy.dairyid) return nil;
    NSString *fileurl = ((FileModel *)[SHValue value:self.dairy.fileJA][index].value).fileurl;
    return [NSURL URLWithString:fileurl];
}



+ (CGFloat)cellHeightWithObj:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    
    Dairy *dairy = [modelDairy.dairy transformDairy];
    CGFloat cellHeight = 0;
    
    cellHeight += needTopView ? 20 : 0;
    cellHeight += 11.0;
    
    cellHeight += dairy.dairytype == 1 ? 0 :  [self mediaViewHeight:dairy];
    //Tweet内容+时间
    cellHeight += [self contentLabelHeightWithTweet:dairy];
    //赞
    cellHeight += [self zanLabelHeightWithZanArr:modelDairy.listModelDairyzan] ? [self zanLabelHeightWithZanArr:modelDairy.listModelDairyzan] : modelDairy.listModelDairycomm.count > 0 ? 12 : 0;
    
    cellHeight += [self commentListViewHeightWithmodelDairy:modelDairy] ?  [self commentListViewHeightWithmodelDairy:modelDairy] + 73 : 0;
    
    cellHeight += needBottomView ? BOTTOMHEIGHT : 0;
    return ceilf(cellHeight);
}

+ (CGFloat)contentLabelHeightWithTweet:(Dairy *)dairy{
    CGFloat height = 0;
    if (dairy.dairydesc.length > 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, kTreetMedia_Wtith - 24, 10)];
        label.font = kTreet_ContentFont;
        if (kHeightFourLine < [[dairy.dairydesc stringByRemovingPercentEncoding] getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 24, CGFLOAT_MAX)]) {
            if (dairy.isFullText) {
                height += [[dairy.dairydesc stringByRemovingPercentEncoding] getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 24, CGFLOAT_MAX)] + FullTextButtonHeight;
            } else {
                height += kHeightFourLine + FullTextButtonHeight;
            }
        } else {
            height += [[dairy.dairydesc stringByRemovingPercentEncoding] getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 24, CGFLOAT_MAX)];
        }
        height += 20+34;
    }else{
        height += 20+34;
    }
    return height;
}

+ (CGFloat)zanLabelHeightWithZanArr:(NSArray <Dairyzan *>*)listModelDairyzan{
    CGFloat zankaH = 0;
    __block NSString *zanla;
    [listModelDairyzan enumerateObjectsUsingBlock:^(Dairyzan *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            zanla = [obj.username stringByRemovingPercentEncoding];
        }else{
            zanla = [NSString stringWithFormat:@"%@,%@",zanla,[obj.username stringByRemovingPercentEncoding]];
        }
    }];
    CGSize zanLableH = [zanla getSizeWithFont:[UIFont systemFontOfSize:13 weight:10] constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 63, CGFLOAT_MAX)];
    zankaH = zanLableH.height;
    zankaH += zankaH > 0 ? 26 : 0;
    return zankaH;
}

+ (CGFloat)commentListViewHeightWithmodelDairy:(modelDairy *)modelDairy{
    if (!modelDairy) {
        return 0;
    }
    CGFloat commentListViewHeight = 0;
    
    for (int i = 0; i < (modelDairy.listModelDairycomm.count >= 6 ? 6 : modelDairy.listModelDairycomm.count); i++) {
        TweetComment *curComment = [modelDairy.listModelDairycomm objectAtIndex:i];
        commentListViewHeight += [commentTabbleCell cellHeightWithObj:curComment];
    }
    if (modelDairy.listModelDairycomm.count >= 6) {
        commentListViewHeight += 25;
    }
    return commentListViewHeight;
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

-(UICustomCollectionView *)mediaView{
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICustomCollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_line.frame)+11, CGRectGetMaxY(_icon.frame)+9, kTreetMedia_Wtith, 0) collectionViewLayout:layout];
        _mediaView.scrollEnabled = NO;
        [_mediaView setBackgroundColor:[UIColor whiteColor]];
        [_mediaView registerClass:[HouerInfoMediaItemCCell class] forCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem];
        _mediaView.dataSource = self;
        _mediaView.delegate = self;
        [self.contentView addSubview:_mediaView];
    }
    return _mediaView;
}

-(UIView *)contentsView{
    if (!_contentsView) {
        _contentsView = [[UIView alloc]initWithFrame:CGRectMake(_mediaView.x, CGRectGetMaxY(_mediaView.frame), kTreetMedia_Wtith, 34)];
        _contentsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentsView];
    }
    return _contentsView;
}

-(UILabel *)tweetContent{
    if (!_tweetContent) {
        _tweetContent = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, _contentsView.width - 24, 10)];
        _tweetContent.textColor = [UIColor blackColor];
        _tweetContent.font = kTreet_ContentFont;
        [_contentsView addSubview:_tweetContent];
    }
    return _tweetContent;
}

- (UIButton *)fullTextButton {
    if (!_fullTextButton) {
        _fullTextButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, 60, 0)];
        [_fullTextButton setTitle:@"查看全文" forState:UIControlStateNormal];
        [_fullTextButton setTitle:@"收起" forState:UIControlStateSelected];
        [_fullTextButton setTitleColor:[UIColor colorWithHexString:@"0x5386a8"] forState:UIControlStateNormal];
        _fullTextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _fullTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentsView addSubview:_fullTextButton];
        [_fullTextButton addTarget:self action:@selector(showFullText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullTextButton;
}

-(UILabel *)timeView{
    if (!_timeView) {
        _timeView = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, _contentsView.width-24, 34)];
        _timeView.textColor = XWColorFromHex(0xbfbfbf);
        _timeView.font = [UIFont systemFontOfSize:11];
        [_contentsView addSubview:_timeView];
    }
    return _timeView;
}

//赞View
-(UIView *)zanView{
    if (!_zanView) {
        _zanView = [[UIView alloc]initWithFrame:CGRectMake(_mediaView.x, CGRectGetMaxY(_contentsView.frame), kTreetMedia_Wtith, 0)];
        _zanView.backgroundColor = [UIColor whiteColor];
        _zanView.clipsToBounds = YES;
        [self.contentView addSubview:_zanView];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(9, 0, _zanView.width - 18, 0.5)];
        line.backgroundColor = kLineColer;
        [_zanView addSubview:line];
    }
    return _zanView;
}

-(UIImageView *)zanIcon{
    if (!_zanIcon) {
        UIImage *image = [UIImage imageNamed:@"praise_iconS"];
        _zanIcon = [[UIImageView alloc]initWithImage:image];
        _zanIcon.size = image.size;
        _zanIcon.x = 9;
        _zanIcon.y = 13;
        [_zanView addSubview:_zanIcon];
    }
    return _zanIcon;
}

-(UILabel *)zanLabel{
    if (!_zanLabel) {
        _zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_zanIcon.frame), 0, _contentsView.width-63, 0)];
        _zanLabel.textColor = kTitleAddHouseTitleCOLOR;
        _zanLabel.font = [UIFont systemFontOfSize:13 weight:10];
        [_zanView addSubview:_zanLabel];
    }
    return _zanLabel;
}


//评论View
-(UIView *)commentView{
    if (!_commentView) {
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(_mediaView.x, CGRectGetMaxY(_zanLabel.frame), kTreetMedia_Wtith, 0)];
        _commentView.backgroundColor = [UIColor whiteColor];
        _commentView.clipsToBounds = YES;
        [self.contentView addSubview:_commentView];
    }
    return _commentView;
}

-(UIImageView *)commentIcon{
    if (!_commentIcon) {
        UIImage *image = [UIImage imageNamed:@"Tcomment_icon"];
        _commentIcon = [[UIImageView alloc]initWithImage:image];
        _commentIcon.size = image.size;
        _commentIcon.x = 9;
        _commentIcon.y = 3;
        [_commentView addSubview:_commentIcon];
    }
    return _commentIcon;
}


-(UITableView *)commentTabble{
    if (!_commentTabble) {
        _commentTabble = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_commentIcon.frame)+6, _commentIcon.y-3, kTreetMedia_Wtith-CGRectGetMaxX(_commentIcon.frame)-6-12, 200) style:(UITableViewStylePlain)];
        _commentTabble.dataSource = self;
        _commentTabble.delegate = self;
        _commentTabble.showsVerticalScrollIndicator = NO;
        _commentTabble.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTabble.scrollEnabled = NO;
        [_commentTabble registerClass:[commentTabbleCell class] forCellReuseIdentifier:@"cell"];
        [_commentView addSubview:_commentTabble];
    }
    return _commentTabble;
}

- (UIImageView *)cornerClockImageView {
    if (!_cornerClockImageView) {
        _cornerClockImageView = [[UIImageView alloc] init];
        [_contentsView addSubview:_cornerClockImageView];
        [_cornerClockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(_contentsView);
            make.size.equalTo(@20);
        }];
        _cornerClockImageView.image = [UIImage imageNamed:@"cornerClock"];
        _cornerClockImageView.hidden = YES;
    }
    return _cornerClockImageView;
}

#pragma mark Collection M
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _modelDairy.listModelDairycomm.count >= 6 ? 7 : _modelDairy.listModelDairycomm.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    commentTabbleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row < 6) {
        TweetComment *commentT = _modelDairy.listModelDairycomm[indexPath.row];
        cell.commentLabel.textColor = kColorBrandGreen;
        [cell configWithComment:commentT topLine:NO];
        cell.allCommentLabel.hidden = YES;
        return cell;
    }else{
        cell.allCommentLabel.text = [NSString stringWithFormat:@"全部%@条评论",_modelDairy.countdairycomm];
        cell.allCommentLabel.font = [UIFont systemFontOfSize:12 weight:10];
        cell.allCommentLabel.textColor = XWColorFromHex(0x95a6c8);
        cell.allCommentLabel.x = 0;
        cell.allCommentLabel.frame = cell.commentLabel.frame;
        cell.allCommentLabel.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.row >= 6) {
        cellHeight = 25;
    }else{
        TweetComment *commentT = _modelDairy.listModelDairycomm[indexPath.row];
        cellHeight = [commentTabbleCell cellHeightWithObj:commentT];
    }
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.CommentReply) {
        self.CommentReply(_modelDairy, indexPath.row);
    }
}


// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//我也说两句
-(UILabel *)meTalk{
    if (!_meTalk) {
        _meTalk = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, kTreetMedia_Wtith-18, 40)];
        _meTalk.layer.borderColor = XWColorFromHex(0xebebeb).CGColor;
        _meTalk.layer.borderWidth = 1.0f;
        _meTalk.layer.cornerRadius = 3.0f;
        _meTalk.text = @"  我也说两句";
        _meTalk.textColor = XWColorFromHex(0xbfbfbf);
        _meTalk.font = [UIFont systemFontOfSize:13];
        _meTalk.userInteractionEnabled = YES;
        [_commentView addSubview:_meTalk];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(meTalkClick)];
        [_meTalk addGestureRecognizer:tap];
        
    }
    return _meTalk;
}

-(void)meTalkClick{
    
    if (self.CommentReply) {
        self.CommentReply(_modelDairy , -1);
    }
}


-(UIButton *)commentBtn{
    if (!_commentBtn) {
        UIImage *image = [UIImage imageNamed:@"commentBtn_icon"];
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:image forState:UIControlStateNormal];
        _commentBtn.size = CGSizeMake(image.size.width*2, image.size.height*2);
        _commentBtn.centerY = _timeView.centerY;
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2);
        _commentBtn.x = kTreetMedia_Wtith-9-image.size.width*1.5;
        [_commentBtn addTarget:self action:@selector(CommentClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentsView addSubview:_commentBtn];
    }
    return _commentBtn;
}
//更多被点击
-(void)CommentClick:(UIButton *)btn{
    CommentPopView *popV = [[CommentPopView alloc]init];
    // 不仅仅自己能编辑，拥有编辑权限的亲友一样可以编辑
//    if (_house.isedit) {
//        popV.isMaster = (_dairy.uid == [Login curLoginUserID]) || (_house.houseisself == 1);
//    } else {
//        popV.isMaster = NO;
//    }
    if (_house.uidcreater == [Login curLoginUserID]) { // 如果是房屋主人有编辑权限
        popV.isMaster = YES;
    } else if (_house.isedit && _dairy.uid == [Login curLoginUserID]) {
        popV.isMaster = YES;
    } else {
        popV.isMaster = NO;
    }    
    [popV ShowCommentWirhToView:btn praises:_modelDairy.listModelDairyzan];
    WEAKSELF
    popV.CommentPopBtnClick = ^(NSInteger tag, BOOL isZan) {
        if (tag == 1) {//点赞
            [weakSelf request_TimerShaftZan:isZan Tag:tag];
            return;
        }
        if (tag == 2) {//评论
            if (weakSelf.CommentReply) {
                weakSelf.CommentReply(_modelDairy , -1);
            }
            return;
        }
        if (tag == 3) {
            SharePopView *share = [[SharePopView alloc]init];
            share.finishSelectde = ^(NSInteger tag) {
                [weakSelf Share:tag];
            };
            [share Show];
        }
        if (self.MoreClick) {
            self.MoreClick(tag,nil,nil,_modelDairy);
        }
        
    };
}

//点赞
-(void)request_TimerShaftZan:(BOOL)iszan Tag:(NSInteger)tag{
    User *user = [Login curLoginUser];
    
    Dairyzan *zan = [[Dairyzan alloc]init];
    zan.dairyzanuid = user.uid;
    zan.dairyid = _dairy.dairyid;
    zan.houseid = _dairy.houseid;
    
    if (self.MoreClick) {
        self.MoreClick(tag,zan,iszan,_modelDairy);
    }
}

#pragma mark - event response
//分享
-(void)Share:(NSInteger)tag{
    
    NSString *platform;
    NSInteger UMSocialPlatformType = 0;
    UMShareWebpageObject *WebpageObject;
    switch (tag) {
        case 1: {
            UMSocialPlatformType = UMSocialPlatformType_WechatSession;
            platform = @"1";
            NSString *mainTitle = [NSString stringWithFormat:@"“%@”的新变化",_house.housename];
            NSString *subTitle = _dairy.dairydesc.length > 0 ? [_dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”哪里不一样了呢？",_house.housename];
            WebpageObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:subTitle thumImage:_modelDairy.dairy.urlshare];
        }
            break;
            
        case 2: {
            UMSocialPlatformType = UMSocialPlatformType_WechatTimeLine;
            platform = @"2";
            NSString *mainTitle = _dairy.dairydesc.length > 0 ? [_dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”的新变化吧！",_house.housename];
            WebpageObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:@"" thumImage:_modelDairy.dairy.urlshare];
        }
            break;
            
        case 3: {
            UMSocialPlatformType = UMSocialPlatformType_QQ;
            platform = @"3";
            NSString *mainTitle = _house.housename;
            NSString *subTitle = _dairy.dairydesc.length > 0 ? [_dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”的新变化吧！",_house.housename];
            WebpageObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:subTitle thumImage:_modelDairy.dairy.urlshare];
        }
            break;
            
        case 4: {
            UMSocialPlatformType = UMSocialPlatformType_Sina;
            platform = @"4";
            NSString *mainTitle = [NSString stringWithFormat:@"快来看看“%@”的新变化吧！",_house.housename];
            WebpageObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:@"" thumImage:_modelDairy.dairy.urlshare];            
        }
            break;
            
        default:
            break;
            
    }

    WEAKSELF
    //创建分享消息对象
//    UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:@"有数啦" descr:[_dairy.dairydesc stringByRemovingPercentEncoding] thumImage:[UIImage imageNamed:@"w_share_icon"]];
    //设置文本
//    WebpageObject.webpageUrl = [NSString stringWithFormat:@"http://wap.usure.com.cn/static/html/outer/dairy/share.html?dairyid=%ld",_dairy.dairyid];
    if (UMSocialPlatformType == UMSocialPlatformType_Sina) {
        [[[UMShareManager alloc] init] webShare:[platform integerValue] - 1 title:[NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@",_house.housename,_modelDairy.dairy.linkshare] content:@"" url:_modelDairy.dairy.linkshare image:_modelDairy.dairy.urlshare complete:^(NSInteger state) {
            switch (state) {
                case 0: {
                    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.modelDairy.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                        
                    }];
                }
                    break;
                case 1: {
                    
                }
                    break;
                default:
                    break;
            }
        }];
    } else {
        WebpageObject.webpageUrl = _dairy.linkshare;
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:[HouseInfoViewController new] completion:^(id result, NSError *error) {
            if (!error) {
                [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                    
                }];
            }
        }];

    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (CGFloat)mediaViewHeight:(Dairy *)dairy {
    return [[self class] mediaHeight:dairy];
}

+ (double)mediaViewHeight:(Dairy *)dairy {
    return [self mediaHeight:dairy];
}

+ (CGFloat)mediaHeight:(Dairy *)dairy {
    
    if (dairy.fileJA.count == 1) {
        CGFloat wh =  dairy.fileJA.firstObject.filepercentwh;
        if (wh > 1) {
            // 单张横图
            return (kTreetMedia_Wtith) / wh;
        } else if (wh == 1) {
            return kTreetMedia_Wtith;
        } else {
            return kTreetMedia_Wtith;
        }
    } else if (dairy.fileJA.count == 2 ) {
        return (kTreetMedia_Wtith - kTreetMedia_MediaItem_Pading) / 2.0;
    } else if (dairy.fileJA.count == 3) {
        return (kTreetMedia_Wtith - kTreetMedia_MediaItem_Pading * 2) / 3.0;
    } else if (dairy.fileJA.count > 3 && dairy.fileJA.count <= 6) {
        return (kTreetMedia_Wtith - kTreetMedia_MediaItem_Pading * 2) / 3.0 * 2.0 + kTreetMedia_MediaItem_Pading;
    } else {
        return kTreetMedia_Wtith;
    }
}

- (void)showFullText:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.modelDairy.dairy.isFullText = !self.modelDairy.dairy.isFullText;
    _FullText(self);
}

@end

