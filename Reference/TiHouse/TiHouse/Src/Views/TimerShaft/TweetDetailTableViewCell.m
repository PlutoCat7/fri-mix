//
//  TimerShaftTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#define kTreetCell_LinePadingLeft 12.f
#define kTreetMedia_Wtith (kScreen_Width - 24.f)
#define  kTreet_ContentFont [UIFont systemFontOfSize:15]
#define BOTTOMHEIGHT 30

#import "TweetDetailTableViewCell.h"
#import "UICustomCollectionView.h"
#import "HouerInfoMediaItemCCell.h"
#import "NSDate+Common.h"
#import "CommentPopView.h"
#import "commentTabbleCell.h"
#import "Login.h"
#import "SharePopView.h"
#import "HouseTweet.h"

@interface TweetDetailTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic ,retain) UIView *contentsView;//发布文字跟时间的容器
@property (nonatomic ,strong) UILabel *nameView, *timeView ,*tweetContent;
@property (nonatomic ,retain) UIView *zanView;//赞View
@property (nonatomic ,strong) UILabel *zanLabel;//赞
@property (nonatomic ,strong) UIImageView *zanIcon;//赞icon
@property (nonatomic ,retain) UIView *commentView;//评论View
@property (nonatomic ,strong) UIImageView *commentIcon;//评论icon
@property (nonatomic ,strong) UITableView *commentTabble;//评论tabble
@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, retain) CAReplicatorLayer *replicatorLayer_Circle;

@property (nonatomic, strong) Dairy *dairy;

// 文本仅自己可见
@property (nonatomic, strong) UIImageView *cornerClockImageView;


@end

@implementation TweetDetailTableViewCell

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
        [self mediaView];
        [self contentsView];
        [self zanView];
        [self zanIcon];
        [self zanLabel];
        
        [self commentView];
        [self commentIcon];
        [self commentTabble];
        
        [self cornerClockImageView];
        
    }
    return self;
}


- (void)setmodelDairy:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    
    _modelDairy = modelDairy;
    _dairy = [_modelDairy.dairy transformDairy];
    _topView.height = needTopView ? 20 : 0;
    
    if (_dairy.dairytype == 1) { // 仅仅只有文本时的锁
        if (_dairy.dairyrangetype && _dairy.dairyrangetype != 3) {
            self.cornerClockImageView.hidden = NO;
        } else {
            self.cornerClockImageView.hidden = YES;
        }
    } else {
        self.cornerClockImageView.hidden = YES;
    }
    //图片
    _mediaView.frame = CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_topView.frame), kTreetMedia_Wtith,[TweetDetailTableViewCell madeHWithTweet:[modelDairy.dairy transformDairy]]);
    if (_dairy.dairytype == 1) {
        CGRect frame = _mediaView.frame;
        frame.size.height = 0;
        _mediaView.frame = frame;
    }
    //Tweet内容
    [self.tweetContent setLongString:[_dairy.dairydesc stringByRemovingPercentEncoding] withFitWidth:kTreetMedia_Wtith - 50 maxHeight:500];
    //用户名及发布时间
    NSString *timeViewStr = [NSString stringWithFormat:@"%@，%@",_modelDairy.nickname,[[NSDate dateWithTimeIntervalSince1970:_dairy.createtime/1000] stringDisplay_HHmm]];
    self.timeView.text = timeViewStr;
    _timeView.y = CGRectGetMaxY(_tweetContent.frame);
    _contentsView.frame = CGRectMake(_mediaView.x, CGRectGetMaxY(_mediaView.frame), kTreetMedia_Wtith, CGRectGetMaxY(_tweetContent.frame)+34);
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
        [_zanLabel setLongString:zanla withFitWidth:kTreetMedia_Wtith - 63 maxHeight:250];
        _zanIcon.x = 9;
        _zanIcon.y = 13;
        _zanLabel.centerY = _zanIcon.centerY;
        _zanLabel.x = CGRectGetMaxX(_zanIcon.frame)+6;
        _zanView.frame = CGRectMake(_contentsView.x, CGRectGetMaxY(_contentsView.frame), _contentsView.width, CGRectGetMaxY(_zanLabel.frame) + 13);

    }else if(modelDairy.listModelDairycomm.count > 0){
        _zanView.frame = CGRectMake(_contentsView.x, CGRectGetMaxY(_contentsView.frame), _contentsView.width, 12);
        _zanView.height = 12;
    }else{
        _zanView.height = 0;
    }
    //评论
    if (_modelDairy.listModelDairycomm.count>0) {
        _commentView.x = _mediaView.x;
        _commentView.y = CGRectGetMaxY(_zanView.frame);
        _commentTabble.height = [TweetDetailTableViewCell commentListViewHeightWithmodelDairy:_modelDairy];
        _commentView.height = _commentTabble.height+12;
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
//    return _dairy.urlfilesmallArr.count;
    return _dairy.fileJA.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HouerInfoMediaItemCCell *curMediaItem = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_HouerInfoMediaItem forIndexPath:indexPath];
    curMediaItem.imageV.alpha = 0;
    
    NSString *url = [SHValue<FileModel *> value:_dairy.fileJA.firstObject].value.fileurl;

    if ([url hasSuffix:@"mp4"]) {
        [curMediaItem.imageV sd_setImageWithURL:[NSURL URLWithString:[_dairy.fileJA[indexPath.row] fileurlsmall]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:.5 animations:^{
                curMediaItem.imageV.alpha = 1.0f;
            }];
            if ([[_dairy.fileJA[indexPath.row] fileurl] containsString:@".mp4"]) {
                for (UIView *view in curMediaItem.imageV.subviews) {
                    [view removeFromSuperview];
                }
                UIImageView *playIconView = [[UIImageView alloc] init];
                playIconView.image = [UIImage imageNamed:@"video_icon"];
                playIconView.frame = CGRectMake(0, 0, playIconView.image.size.width, playIconView.image.size.height);
                playIconView.center = curMediaItem.center;
                [curMediaItem.imageV addSubview:playIconView];
            }
            
        }];

    } else {
        [curMediaItem.imageV sd_setImageWithURL:[NSURL URLWithString:[_dairy.fileJA[indexPath.row] fileurlsmall]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:.5 animations:^{
                curMediaItem.imageV.alpha = 1.0f;
            }];
            if ([[_dairy.fileJA[indexPath.row] fileurl] containsString:@".mp4"]) {
                for (UIView *view in curMediaItem.imageV.subviews) {
                    [view removeFromSuperview];
                }
                UIImageView *playIconView = [[UIImageView alloc] init];
                playIconView.image = [UIImage imageNamed:@"video_icon"];
                playIconView.frame = CGRectMake(0, 0, playIconView.image.size.width, playIconView.image.size.height);
                playIconView.center = curMediaItem.center;
                [curMediaItem.imageV addSubview:playIconView];
            }
            
        }];

    }
    
    curMediaItem.vidoImage.hidden = YES;
    //非所有人可见
    if (_dairy.dairyrangetype != 3) {
        curMediaItem.cornerClock.hidden = NO;;
    }else{
        curMediaItem.cornerClock.hidden = YES;;
    }
    
    return curMediaItem;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FileModel *fileModel = _dairy.fileJA[indexPath.row];
    CGSize itemSize;
//    if ([dic objectForKey:@"H"]) {
//       itemSize = CGSizeMake(_mediaView.width,_mediaView.width/[dic[@"W"] floatValue]*[dic[@"H"] floatValue]);
//    }else{
//        itemSize = CGSizeMake(_mediaView.width,0);
//    }
    itemSize = CGSizeMake(_mediaView.width, _mediaView.width / fileModel.filepercentwh);
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection;
    insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
    return insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_modelDairy.dairy.dairytype == 3) {
        if (_PlayVido) {
            _PlayVido(_modelDairy);
        }
        return;
    }
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _dairy.fileJA.count;
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
    
    return [NSURL URLWithString:[_dairy.fileJA[index] fileurl]];
}



+ (CGFloat)cellHeightWithObj:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView{
    
    Dairy *dairy = [modelDairy.dairy transformDairy];
    CGFloat cellHeight = 0;
    
    cellHeight += needTopView ? 20 : 0;
    cellHeight += 11.0;
//    cellHeight += 211;
    cellHeight += [self madeHWithTweet:dairy];
    //Tweet内容+时间
    cellHeight += [self contentLabelHeightWithTweet:dairy];
    //赞
    cellHeight += [self zanLabelHeightWithZanArr:modelDairy.listModelDairyzan] ? [self zanLabelHeightWithZanArr:modelDairy.listModelDairyzan] : modelDairy.listModelDairycomm.count > 0 ? 12 : 0;

    cellHeight += [self commentListViewHeightWithmodelDairy:modelDairy] ?  [self commentListViewHeightWithmodelDairy:modelDairy] : 0;

    cellHeight += needBottomView ? BOTTOMHEIGHT : 0;
    
    cellHeight += 100;
    
    return ceilf(cellHeight);
}

+(NSInteger)madeHWithTweet:(Dairy *)dairy{
    CGFloat height = 0;
    for (FileModel *fileModel in dairy.fileJA) {
        height += kTreetMedia_Wtith / fileModel.filepercentwh;
    }
    return dairy.fileJA.count == 0 ? 0 : height + (dairy.fileJA.count - 1) * 10;
}

+ (CGFloat)contentLabelHeightWithTweet:(Dairy *)dairy{
    CGFloat height = 0;
    if (dairy.dairydesc.length > 0) {
        height += MIN(200, [dairy.dairydesc getHeightWithFont:kTreet_ContentFont constrainedToSize:CGSizeMake(kTreetMedia_Wtith - 50, CGFLOAT_MAX)]);
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
    CGSize zanLableH = [zanla getSizeWithFont:[UIFont systemFontOfSize:13 weight:10] constrainedToSize:CGSizeMake(kTreetMedia_Wtith, CGFLOAT_MAX)];
    zankaH = zanLableH.height;
    zankaH += zankaH > 0 ? 26 : 0;
    return zankaH;
}

+ (CGFloat)commentListViewHeightWithmodelDairy:(modelDairy *)modelDairy{
    if (!modelDairy) {
        return 0;
    }
    CGFloat commentListViewHeight = 0;
    for (int i = 0; i < modelDairy.listModelDairycomm.count; i++) {
        TweetComment *curComment = [modelDairy.listModelDairycomm objectAtIndex:i];
        commentListViewHeight += [commentTabbleCell cellHeightWithObj:curComment];
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

-(UICustomCollectionView *)mediaView{
    if (!_mediaView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mediaView = [[UICustomCollectionView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, 0, kTreetMedia_Wtith, 211) collectionViewLayout:layout];
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
        _contentsView = [[UIView alloc]initWithFrame:CGRectMake(kTreetCell_LinePadingLeft, CGRectGetMaxY(_mediaView.frame), kTreetMedia_Wtith, 34)];
        _contentsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentsView];
    }
    return _contentsView;
}

-(UILabel *)tweetContent{
    if (!_tweetContent) {
        _tweetContent = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, kTreetMedia_Wtith - 50, 10)];
        _tweetContent.textColor = [UIColor blackColor];
        _tweetContent.font = kTreet_ContentFont;
        [_contentsView addSubview:_tweetContent];
    }
    return _tweetContent;
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
        _zanView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentsView.frame), kTreetMedia_Wtith, 0)];
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
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(_mediaView.x, CGRectGetMaxY(_zanView.frame), kTreetMedia_Wtith, 0)];
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
        _commentTabble = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_commentIcon.frame)+6, _commentIcon.y-3, kTreetMedia_Wtith-CGRectGetMaxX(_commentIcon.frame)-6-12, 0) style:(UITableViewStylePlain)];
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
// 小锁
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
    return _modelDairy.listModelDairycomm.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    commentTabbleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TweetComment *commentT = _modelDairy.listModelDairycomm[indexPath.row];
    [cell configWithComment:commentT topLine:NO];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    //    if (indexPath.row >= _modelDairy.listModelDairycomm.count) {
    ////        cellHeight = [commentTabbleCell cellHeight];
    //    }else{
    TweetComment *commentT = _modelDairy.listModelDairycomm[indexPath.row];
    cellHeight = [commentTabbleCell cellHeightWithObj:commentT];
    //    }
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
//        if (tag == 3) {
//            SharePopView *share = [[SharePopView alloc]init];
//            share.finishSelectde = ^(NSInteger tag) {
//                [weakSelf Share:tag];
//            };
//            [share Show];
//        }
        if (self.MoreClick) {
            self.MoreClick(tag,nil,nil);
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
        self.MoreClick(tag,zan,iszan);
    }
}

#pragma mark - event response
//分享
-(void)Share:(NSInteger)tag{
    NSString *platform;
    NSInteger UMSocialPlatformType = 0;
    switch (tag) {
        case 1:
            UMSocialPlatformType = UMSocialPlatformType_WechatSession;
            platform = @"1";
            break;
            
        case 2:
            UMSocialPlatformType = UMSocialPlatformType_WechatTimeLine;
            platform = @"2";
            break;
            
        case 3:
            UMSocialPlatformType = UMSocialPlatformType_QQ;
            platform = @"3";
            break;
            
        case 4:
            UMSocialPlatformType = UMSocialPlatformType_Sina;
            platform = @"4";
            break;
            
        default:
            break;
            
    }
    WEAKSELF
    //创建分享消息对象
    UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:@"有数啦" descr:_dairy.dairydesc thumImage:[UIImage imageNamed:@"w_share_icon"]];
    //设置文本
    WebpageObject.webpageUrl = _dairy.linkshare;//[NSString stringWithFormat:@"http://wap.usure.com.cn/static/html/outer/dairy/share.html?dairyid=%ld",_dairy.dairyid];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:[TweetDetailTableViewCell new] completion:^(id result, NSError *error) {
        if (!error) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.modelDairy.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                
            }];
        }
    }];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

