//
//  TweetDetailsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#define kCommentIndexNotFound -1

#import "TweetDetailsViewController.h"
#import "TweetDetailTableViewCell.h"
#import "UIMessageInputView.h"
#import "SharePopView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HouseTweet.h"
#import "HouseTweetEditViewController.h"
#import "Login.h"
#import "TiHouseNetAPIClient.h"
#import "TiHouse_NetAPIManager.h"
#import "HXPhotoManager.h"
#import "Dairyzan.h"
#import "PXAlertView.h"
#import "PXAlertView+Customization.h"

#import <IQKeyboardManager.h>
#import "UMShareManager.h"

@interface TweetDetailsViewController ()<UITableViewDelegate, UITableViewDataSource,UIMessageInputViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;
//评论
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) TweetComment *commentTweet;
@property (nonatomic, assign) NSInteger commentIndex;
@property (nonatomic, strong) UIView *commentSender;
@property (nonatomic, retain) MPMoviePlayerViewController *mPMoviePlayerViewController;
//@property (nonatomic, strong) modelDairy *modelDairy;
@property (strong, nonatomic) HXPhotoManager *manager;


@end

@implementation TweetDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 从云评论点击来的
    if (self.dairyid) {
        [self tableView];
        [self setData];
        //初始化modelDairy
        //要不会crash
        self.modelDairy = [[modelDairy alloc] init];
        self.modelDairy.dairy = [[Dairy alloc] init];
        self.modelDairy.dairy.dairyid = self.dairyid;
    } else {
        // 从时间轴来的
        [self tableView];
        [self currentMonthreFresh];
    }
    //评论输入框
    _myMsgInputView = [UIMessageInputView messageInputView];
    _myMsgInputView.isAlwaysShow = YES;
    _myMsgInputView.delegate = self;
}

- (void)setData
{
    
    //    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getDetail" withParams:@{@"uid":[NSNumber numberWithLong:[Login curLoginUserID]], @"dairyid":[NSNumber numberWithLong:self.dairyid]} withMethodType:(Post) autoShowError:NO andBlock:^(id data, NSError *error) {
    //
    //    }];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":@(self.dairyid)} withMethodType:(Post) autoShowError:NO andBlock:^(id data, NSError *error) {
        if (SHVALUE(data)[@"is"].intValue == 1) {
            [self currentMonthreFresh];//如果是从云记录进来的 需要请求评论接口
            NSDictionary *modelDairydata = data[@"data"];
            self.modelDairy = [[modelDairy alloc] init];
            self.modelDairy.nickname = data[@"data"][@"nickname"];
            //            self.modelDairy.dairy =[[Dairy mj_objectWithKeyValues:modelDairydata[@"dairy"]] transformDairy];
            self.modelDairy.dairy =[[Dairy mj_objectWithKeyValues:modelDairydata] transformDairy];
            self.modelDairy.listModelDairyzan = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in modelDairydata[@"listModelDairyzan"]) {
                [self.modelDairy.listModelDairyzan addObject:[Dairyzan mj_objectWithKeyValues:dic]];
            }
            self.modelDairy.listModelDairycomm = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in modelDairydata[@"listModelDairycomm"]) {
                [self.modelDairy.listModelDairycomm addObject:[TweetComment mj_objectWithKeyValues:dic]];
            }
            if (self.modelDairy.dairy.fileJA.count == 0) {
                [self.tableView reloadData];
            } else {
                __block int j = 0;
                for (int i = 0; i < self.modelDairy.dairy.fileJA.count; i++) {
                    [[[SDWebImageManager sharedManager] imageDownloader]downloadImageWithURL:[NSURL URLWithString:[self.modelDairy.dairy.fileJA[i] fileurlsmall]] options:1 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        
                        j++;
                        if (j == self.modelDairy.dairy.fileJA.count) {
                            [self tableView];
                            //                        [self currentMonthreFresh];
                        }
                        [self.tableView reloadData];
                    }];
                }
            }
        } else {
            PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"错误"
                                                             message:data[@"msg"]
                                                         cancelTitle:@"确定"
                                                          completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
            [alertView useDefaultIOS7Style];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //键盘
    [_myMsgInputView prepareToShow];
    [_tableView reloadData];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
    if (_relodaDataCallback) {
        _relodaDataCallback();
    }
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (TweetComment *)commentTweet {
    if (!_commentTweet) {
        _commentTweet = [[TweetComment alloc]init];
        _commentTweet.dairyid = _modelDairy.dairy.dairyid;
        _commentTweet.dairycommuidon = _modelDairy.dairy.uid;
        _commentTweet.houseid = _house.houseid;
    }
    return _commentTweet;
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    
    self.commentTweet.dairycommcontent = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sendCommentMessage:text];
}

#pragma mark Comment To Tweet
- (void)sendCommentMessage:(id)obj{
    if (_commentIndex >= 0) {
    }else{
    }
    [self sendCurComment:_commentTweet];
    {
        
    }
    self.myMsgInputView.placeHolder = @"说点什么......点评一下";
    [self.myMsgInputView isAndResignFirstResponder];
}

- (void)sendCurComment:(TweetComment *)commentObj{
    [NSObject showStatusBarQueryStr:@"正在发表评论..."];
    __weak typeof(self) weakSelf = self;
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftTweetComment:commentObj Block:^(id data, NSError *error) {
        if (data) {
            [NSObject showStatusBarSuccessStr:@"发表成功！"];
            if (weakSelf.commentIndex<=0) {
                [weakSelf.modelDairy.listModelDairycomm addObject:(TweetComment *)data];
            }else{
                [weakSelf.modelDairy.listModelDairycomm insertObject:(TweetComment *)data atIndex:weakSelf.commentIndex+1];
            }
            weakSelf.commentTweet = nil;
            weakSelf.commentIndex = kCommentIndexNotFound;
            weakSelf.commentSender = nil;
            [weakSelf.tableView reloadData];
        }
        else{
            [NSOrderedSet showStatusBarErrorStr:@"评论失败！"];
        }
        
    }];
}
//点赞
-(void)zanClickWithDairyzan:(Dairyzan *)zan isZan:(BOOL)iszan IndexPath:(NSIndexPath *)indexPath modelDairy:(modelDairy *)modelDairy{
    //    [CATransaction begin];
    if (!iszan) {
        [modelDairy CancelZan];
        self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
        self.tableView.scrollEnabled = YES;
    }
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftZanWithDairyzan:zan isZan:iszan Block:^(id data, NSError *error) {
        if (data) {
            if (iszan) {
                [modelDairy ClickZan:(Dairyzan *)data];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    TweetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetDetailTableViewCell" forIndexPath:indexPath];
    [cell setmodelDairy:_modelDairy needTopView:NO needBottomView:NO];
    cell.house = _house;
    //播放视频
    __weak typeof(TweetDetailTableViewCell) *weakCell = cell;
    cell.PlayVido = ^(modelDairy *modelDairy) {
        
        //        weakSelf.mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:modelDairy.dairy.arrurlfileArr.firstObject]];
        //        weakSelf.mPMoviePlayerViewController.view.frame = CGRectMake(0, 100, 414, 300);
        //        [self presentViewController:weakSelf.mPMoviePlayerViewController animated:YES completion:nil];
        
        //        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        //        configuration.shouldAutoPlay = YES;
        //        configuration.supportedDoubleTap = YES;
        //        configuration.shouldAutorotate = YES;
        //        //            configuration.repeatPlay = YES;
        //        configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
        //        configuration.sourceUrl = [NSURL URLWithString:modelDairy.dairy.arrurlfileArr.firstObject];
        //        configuration.videoGravity = SelVideoGravityResizeAspect;
        //        CGFloat width = self.view.frame.size.width;
        //        SelVideoPlayer *player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height) configuration:configuration];
        //        [self.navigationController.navigationBar addSubview:player];
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.isVideo = YES;
        photoBrowser.delegate = self;
        photoBrowser.browserType = PhotoBrowserTyoeTyoeTimerShaft;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = weakSelf.modelDairy.dairy.fileJA.count;
        photoBrowser.sourceImagesContainerView = weakCell.mediaView;
        photoBrowser.dairy = weakSelf.modelDairy.dairy;
        
        [photoBrowser show];
        
        
    };
    //点击赞
    cell.MoreClick = ^(NSInteger tag, Dairyzan *zan ,BOOL izan) {
        if (tag == 1) {
            [weakSelf zanClickWithDairyzan:zan isZan:izan IndexPath:indexPath modelDairy:weakSelf.modelDairy];
        }
        if (tag == 3) {
            SharePopView *share = [[SharePopView alloc]init];
            share.finishSelectde = ^(NSInteger tag) {
                [weakSelf Share:tag];
            };
            [share Show];
        }
        if (tag == 4) {
            [self clickEdit:self.modelDairy];
        }
    };
    
    //评论回复
    cell.CommentReply = ^(modelDairy *modelDairy, NSInteger row) {
        weakSelf.modelDairy = modelDairy;
        if (row == -1) {
            weakSelf.commentTweet = [[TweetComment alloc]init];
            weakSelf.commentTweet.dairyid = weakSelf.modelDairy.dairy.dairyid;
            weakSelf.commentTweet.dairycommuidon = weakSelf.modelDairy.dairy.uid;
            weakSelf.commentTweet.houseid = weakSelf.house.houseid;
            [weakSelf.myMsgInputView notAndBecomeFirstResponder];
        }else{
            weakSelf.commentIndex = row;
            weakSelf.commentTweet = [[TweetComment alloc]init];
            weakSelf.commentTweet.houseid = weakSelf.house.houseid;
            weakSelf.commentTweet.dairycommuidon = modelDairy.listModelDairycomm[row].dairycommuid;
            weakSelf.commentTweet.dairyid = modelDairy.listModelDairycomm[row].dairyid;
            weakSelf.commentTweet.dairycommid = modelDairy.listModelDairycomm[row].dairycommid;
            weakSelf.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复：%@",[modelDairy.listModelDairycomm[row].dairycommname stringByRemovingPercentEncoding]];
            [weakSelf.myMsgInputView notAndBecomeFirstResponder];
        }
        
    };
    
    return cell;
}


#pragma mark - private methods 私有方法

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
//    UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:@"有数啦" descr:[_modelDairy.dairy.dairydesc stringByRemovingPercentEncoding] thumImage:[UIImage imageNamed:@"w_share_icon"]];
    NSString *mainTitle;
    NSString *subTitle;
    switch (tag) {
        case 1:
            mainTitle = [NSString stringWithFormat:@"“%@”的新变化", _house.housename];
            subTitle = _modelDairy.dairy.dairydesc.length > 0 ? [_modelDairy.dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”哪里不一样呢？", _house.housename];
            break;
        case 2:
            mainTitle = _modelDairy.dairy.dairydesc.length > 0 ? [_modelDairy.dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”哪里不一样呢？", _house.housename];
            subTitle = @"";
            break;
        case 3:
            mainTitle = _house.housename;
            subTitle = _modelDairy.dairy.dairydesc.length > 0 ? [_modelDairy.dairy.dairydesc stringByRemovingPercentEncoding] : [NSString stringWithFormat:@"快来看看“%@”哪里不一样呢？", _house.housename];
            break;
        case 4:
            mainTitle = [NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@",_house.housename, _modelDairy.dairy.linkshare];
            subTitle = @"";
            break;
        default:
            break;
    }
    if (UMSocialPlatformType == UMSocialPlatformType_Sina) {
        [[[UMShareManager alloc] init] webShare:[platform integerValue] - 1 title:mainTitle content:subTitle url:_modelDairy.dairy.linkshare image:_modelDairy.dairy.urlshare complete:^(NSInteger state) {
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
        UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:mainTitle descr:subTitle thumImage:_modelDairy.dairy.urlshare];
        //设置文本
        WebpageObject.webpageUrl = _modelDairy.dairy.linkshare;
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
            
            if (!error) {
                [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.modelDairy.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                }];
            }
        }];
    }
}

- (void)currentMonthreFresh{
    if (_modelDairy.isLoading) {
        return;
    }
    _modelDairy.canLoadMore = YES;
    _modelDairy.willLoadMore = NO;
    _modelDairy.isLoading = NO;
    _modelDairy.page = @0;
    _modelDairy.pageSize = @20;
    [_tableView.mj_footer resetNoMoreData];
    [self currentMonthresendRequest];
}

- (void)currentMonthreFreshMore{
    if (_modelDairy.willLoadMore || !_modelDairy.canLoadMore) {
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        return;
    }
    _modelDairy.willLoadMore = YES;
    _modelDairy.page = @(20 + [_modelDairy.page intValue]);
    [self currentMonthresendRequest];
}

-(void)currentMonthresendRequest{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftTweetCommentList:_modelDairy Params:@{@"dairyid":@(weakSelf.modelDairy.dairy.dairyid), @"start":_modelDairy.page, @"limit":_modelDairy.pageSize} Block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.modelDairy configWithHouess:data];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            if (weakSelf.isAllComment) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TweetDetailTableViewCell cellHeightWithObj:_modelDairy needTopView:YES needBottomView:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;//section头部高度
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

#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[TweetDetailTableViewCell class] forCellReuseIdentifier:@"TweetDetailTableViewCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(12, 0, 0, 0));
        }];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            //            self.automaticallyAdjustsScrollViewInsets = YES;
            _tableView.estimatedRowHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        WEAKSELF
        //        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            [weakSelf currentMonthreFreshMore];
        //        }];
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    return _manager;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:[_modelDairy.dairy.fileJA[index] fileurlsmall] ];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    return [NSURL URLWithString:[_modelDairy.dairy.fileJA[index] fileurl]];
}

- (void)clickEdit:(modelDairy *)dairy {
    WEAKSELF;
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":@(dairy.dairy.dairyid)} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            Dairy *newDairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
            HouseTweet *tweet = [[HouseTweet alloc]init];
            tweet.dairydesc = newDairy.dairydesc;
            tweet.type = newDairy.dairytype;
            tweet.dairyrangeJAstr = newDairy.dairyrangeJA;
            tweet.dairyremindJAstr = newDairy.dairyremindJA;
            tweet.dairytimetype = newDairy.dairytimetype;
            tweet.house = _house;
            tweet.dairy = dairy;
            tweet.diytime = [NSString stringWithFormat:@"%ld",newDairy.diytime];
            for (FileModel *fileModel in newDairy.fileJA) {
                TweetImage *image = [TweetImage tweetImageWithURL:fileModel.fileurl];
                image.imageStr = fileModel.fileurl;
                image.creationDate = [[NSDate alloc] initWithTimeIntervalSince1970:[fileModel.phototime longLongValue] / 1000];
                image.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileModel.fileurlsmall];
                [tweet.images addObject:image];
            }
            HouseTweetEditViewController *houseTweetEditVC = [[HouseTweetEditViewController alloc]init];
            houseTweetEditVC.isEdit = YES;
            houseTweetEditVC.tweet = tweet;
            if ([newDairy.fileJA.firstObject.fileurl containsString:@".mp4"]) {
                self.manager.type = 1;
            } else {
                self.manager.type = 0;
            }
            houseTweetEditVC.manager = self.manager;
            
            houseTweetEditVC.dairy = newDairy;
            [self.navigationController pushViewController:houseTweetEditVC animated:YES];
            houseTweetEditVC.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
                
                if (isDelete) { // MARK: - TODO 删除
                    
                } else { // MARK: - 编辑
                    
                }
                // MARK: - 编辑
                [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithQiNiu:tweet isEdit:YES Block:^(Dairy *data, NSError *error) {
                    if (data) {
                        [NSObject showStatusBarSuccessStr:@"编辑成功"];
                        dairy.dairy = data;
                        [weakSelf.tableView reloadData];
                        
                    } else {
                        [NSObject showStatusBarSuccessStr:@"编辑失败"];
                    }
                }];
                
                
            };
            [houseTweetEditVC setDeleteCallback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

@end
