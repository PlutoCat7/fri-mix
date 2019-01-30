//
//  THHouseMonthViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "THHouseMonthViewController.h"
#import "TimerShaft.h" // 时间轴数据模型
#import "TimerShaftTableViewCell.h" // 日志cell
#import "RDVTabBarController.h" // 修改tableView的height

#import "HouesInfoCell.h"
#import "AddHouseViewController.h"
#import "UIMessageInputView.h"
#import "HXPhotoPicker.h"
#import "NSDate+Extend.h"
#import "HouseTweet.h"
#import "HouseChangeViewController.h"
#import "HouseTweetEditViewController.h"
#import "TimerShaftTableViewCell.h"
#import "TimerTweets.h"
#import "modelDairy.h"
#import "TweetComment.h"
#import "MoreBtn.h"
#import "SharePopView.h"
#import "TweetDetailsViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "Login.h"
#import "NewScheduleVC.h"
#import "UIImage+Common.h"

#define kCommentIndexNotFound -1

@interface THHouseMonthViewController ()<UITableViewDelegate, UITableViewDataSource, UIMessageInputViewDelegate,HXAlbumListViewControllerDelegate,HXCustomCameraViewControllerDelegate>
{
    NSMutableArray *items;
    CGFloat _oldPanOffsetY;
}
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableDictionary *hXPhotoModelDic;
@property (strong, nonatomic) NSMutableArray *TweetArr;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, retain) TimerTweets *timerTweets;
@property (nonatomic, retain) MoreBtn *MoreBtn;
@property (nonatomic, retain) UIView *line;

//评论
@property (nonatomic, strong) TweetComment *commentTweet;
@property (nonatomic, assign) NSInteger commentIndex;
@property (nonatomic, strong) UIView *commentSender;
@property (nonatomic, strong) modelDairy *modelDairy;
//赞
@property (nonatomic, strong) Dairyzan *zan;

@end

@implementation THHouseMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self wr_setNavBarBarTintColor:[UIColor colorWithHexString:@"0xfdf086"]];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    
    _hXPhotoModelDic = [NSMutableDictionary dictionary];
    _TweetArr = [NSMutableArray new];
    _timerTweets = [[TimerTweets alloc]init];
    _timerTweets.house = _house;
    _timerTweets.canLoadMore = YES;
    [self tableView];
    
    _myMsgInputView = [UIMessageInputView messageInputView];
    _myMsgInputView.isAlwaysShow = NO;
    _myMsgInputView.delegate = self;
    
    // 初始的lasttime
    _timerTweets.currentLastTime = @([[self getMonthBeginAndEndWith:_model.dairymonth] timeIntervalSince1970] * 1000.0f);
    [self currentMonthreFresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [_myMsgInputView prepareToShow];
    [_tableView reloadData];
    [(BaseNavigationController *)self.navigationController showNavBottomLine];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_timerTweets.ALLlist[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    TimerShaft *shaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row];
    TimerShaft *TopshaftCellData;
    if (indexPath.row != 0) {
        TopshaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row-1];
    }
    //    日记样式CELL
    if (shaftCellData.type == 1) {
        
        TimerShaftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_HouesInfo forIndexPath:indexPath];
        cell.house = _house;
        cell.icon.hidden = TopshaftCellData ? [NSDate isAlikeDay:TopshaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
        modelDairy *dairy = shaftCellData.modelDairy;
        [cell setmodelDairy:shaftCellData.modelDairy needTopView:indexPath.row == 0 needBottomView: indexPath.row != [_timerTweets.ALLlist[indexPath.section] count]-1];
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        }else{
            cell.icon.image = [UIImage imageNamed:@"timerShaft_icon"];
        }
        
        cell.FullText = ^(TimerShaftTableViewCell *acell) {
            [weakSelf.tableView reloadData];
        };
        
        //更多
        cell.MoreClick = ^(NSInteger tag, Dairyzan *zan ,BOOL izan,modelDairy *dairy) {
            weakSelf.zan = zan;
            //点击赞
            if (tag == 1) {
                [weakSelf zanClickWithDairyzan:zan isZan:izan IndexPath:indexPath modelDairy:shaftCellData.modelDairy];
            }
            if (tag == 4) {
                [weakSelf clickEdit:dairy];
            }
        };
        //评论回复
        cell.CommentReply = ^(modelDairy *modelDairy, NSInteger row) {
            weakSelf.modelDairy = modelDairy;
            if (row == -1) {
                weakSelf.commentTweet = [[TweetComment alloc]init];
                weakSelf.commentTweet.dairyid = dairy.dairy.dairyid;
                weakSelf.commentTweet.dairycommuidon = dairy.dairy.uid;
                weakSelf.commentTweet.houseid = weakSelf.house.houseid;
                weakSelf.myMsgInputView.placeHolder = @"说点什么......点评一下";
                [weakSelf.myMsgInputView notAndBecomeFirstResponder];
            }else if (row == 6){
                TweetDetailsViewController *TweetDetailsVC = [[TweetDetailsViewController alloc]init];
                TweetDetailsVC.modelDairy = shaftCellData.modelDairy;
                TweetDetailsVC.house = weakSelf.house;
                TweetDetailsVC.title = weakSelf.house.housename;
                TweetDetailsVC.isAllComment = YES;
                [weakSelf.navigationController pushViewController:TweetDetailsVC animated:YES];
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
    UITableViewCell *acell = [tableView dequeueReusableCellWithIdentifier:@"ce"];
    if (!acell) {
        acell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ce"];
    }
    return acell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_line) {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(23));
            make.top.equalTo(@(self->_tableView.contentSize.height-44));
            make.height.equalTo(@(kScreen_Height));
            make.width.equalTo(@(1));
        }];
    }
    
    if (![_timerTweets.ALLlist.firstObject count] && ![_timerTweets.ALLlist.lastObject count]) {
        return kScreen_Height - 255;
    }
    
    TimerShaft *shaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row];
    TimerShaft *BottomhaftCellData;
    if ([_timerTweets.ALLlist[indexPath.section] count]-1 > indexPath.row) {
        BottomhaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row+1];
    }
    BOOL needBottomView = BottomhaftCellData ? [NSDate isAlikeDay:BottomhaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
    if (shaftCellData.type == 1) {
        return [TimerShaftTableViewCell cellHeightWithObj:shaftCellData.modelDairy needTopView:indexPath.row == 0 needBottomView:!needBottomView];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_timerTweets.ALLlist[indexPath.section] count] == 0) {
        return;
    }
    TimerShaft *shaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row];
    TweetDetailsViewController *TweetDetailsVC = [[TweetDetailsViewController alloc]init];
    TweetDetailsVC.modelDairy = shaftCellData.modelDairy;
    TweetDetailsVC.house = _house;
    TweetDetailsVC.title = _house.housename;
    [TweetDetailsVC setRelodaDataCallback:^{
        [self currentMonthresendRequest];
    }];
    [self.navigationController pushViewController:TweetDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    if ([self.timerTweets.ALLlist[0] count] >= 20) {
        return 60;
    }
    return 0.01;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    if ([self.timerTweets.ALLlist[0] count] >= 20) {
        return self.MoreBtn;
    }
    return nil;
}

#pragma mark ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        [self.myMsgInputView isAndResignFirstResponder];
        _oldPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _oldPanOffsetY = 0;
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    _commentTweet.dairycommcontent = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sendCommentMessage:text];
}

#pragma mark Comment To Tweet
- (void)sendCommentMessage:(id)obj{
    [self sendCurComment:_commentTweet];
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

-(void)zanClickWithDairyzan:(Dairyzan *)zan isZan:(BOOL)iszan IndexPath:(NSIndexPath *)indexPath modelDairy:(modelDairy *)modelDairy{
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

#pragma mark - private methods 私有方法
- (void)currentMonthreFresh{
    _timerTweets.currentLastTime = @([[self getMonthBeginAndEndWith:_model.dairymonth] timeIntervalSince1970] * 1000.0f);
    
    if (_timerTweets.currentMonthisLoading) {
        return;
    }
    _timerTweets.currentMonthwillLoadMore = NO;
    [_MoreBtn.moreBtn setTitle:@"加载更多" forState:(UIControlStateNormal)];
    [self currentMonthresendRequest];
}

- (void)currentMonthreFreshMore{
    TimerShaft *shaftData =[self.timerTweets.ALLlist.firstObject lastObject];
    _timerTweets.currentLastTime = @(shaftData.latesttime);

    if (!_timerTweets.currentMonthCanLoadMore) {
        [self.MoreBtn.Roud.layer removeAllAnimations];
        [_MoreBtn.moreBtn setTitle:@"没有更多了！" forState:(UIControlStateNormal)];
        return;
    }
    _timerTweets.currentMonthwillLoadMore = YES;
    [_MoreBtn.Roud.layer addSublayer:[MoreBtn replicatorLayer_Round]];
    [self currentMonthresendRequest];
}

-(void)currentMonthresendRequest{
    WEAKSELF
    NSDictionary *params = @{@"start": @0, @"limit": @20, @"houseid": @(_house.houseid), @"type": @"2", @"latesttime": _timerTweets.currentLastTime};
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/logtimeaxis/pageStatus1ByHouseidnew" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_header endRefreshing];
        [self.MoreBtn.Roud.layer removeAllAnimations];
        if (data) {
            NSArray * timerShaft = [TimerShaft mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            [weakSelf.timerTweets configWithCurrentMonth:timerShaft];
            
            if ([timerShaft count] < 20) {
                weakSelf.timerTweets.currentMonthCanLoadMore = NO;
            } else {
                weakSelf.timerTweets.currentMonthCanLoadMore = YES;
            }
            
        } else {
            weakSelf.timerTweets.currentMonthCanLoadMore = NO;
        }
        [weakSelf line];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[TimerShaftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_HouesInfo];
        _tableView.estimatedRowHeight = 0;
        [self.view addSubview:_tableView];
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf currentMonthreFresh];
        }];
        [_tableView bringSubviewToFront:_tableView.mj_header];
    }
    return _tableView;
}

-(MoreBtn *)MoreBtn{
    if (!_MoreBtn) {
        _MoreBtn = [[MoreBtn alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        [_MoreBtn.moreBtn addTarget:self action:@selector(currentMonthreFreshMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MoreBtn;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 20;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 20;
        _manager.configuration.cellSelectedBgColor = [UIColor clearColor];
        _manager.configuration.themeColor = kRKBNAVBLACK;
    }
    return _manager;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = kLineColer;
        [_tableView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(23));
            make.top.equalTo(@(_tableView.contentSize.height));
            make.height.equalTo(@(kScreen_Height));
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}

- (void)clickEdit:(modelDairy *)dairy {
    WEAKSELF;
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":@(dairy.dairy.dairyid)} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            Dairy *newDairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
            HouseTweet *tweet = [[HouseTweet alloc]init];
            tweet.dairydesc = newDairy.dairydesc;
            tweet.type = newDairy.dairytype;
            tweet.dairytimetype = newDairy.dairytimetype;
            tweet.dairyrangeJAstr = newDairy.dairyrangeJA;
            tweet.dairyremindJAstr = newDairy.dairyremindJA;
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
            houseTweetEditVC.manager = self.manager;
            if ([newDairy.fileJA.firstObject.fileurl containsString:@".mp4"]) {
                self.manager.type = 1;
            } else {
                self.manager.type = 0;
            }

            houseTweetEditVC.dairy = newDairy;
            [self.navigationController pushViewController:houseTweetEditVC animated:YES];
            houseTweetEditVC.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
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
                //        [weakSelf currentMonthresendRequest];
                [weakSelf.timerTweets.ALLlist[0] enumerateObjectsUsingBlock:^(TimerShaft *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.modelDairy isEqual:dairy]) {
                        [weakSelf.timerTweets.ALLlist[0] removeObject:obj];
                    }
                }];
                [weakSelf.tableView reloadData];
            }];

        }
    }];

}

// 判断最大日期
- (NSString *)maxTimestamp:(NSArray *)array {
    
    __block NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
    [array enumerateObjectsUsingBlock:^(TweetImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lastDate = [lastDate laterDate:obj.creationDate];
    }];
    return [NSString stringWithFormat:@"%ld", (long)([lastDate timeIntervalSince1970]*1000)] ;
}

// 获取最后一天
- (NSDate *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
//    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *time = [NSString stringWithFormat:@"%@ 23:59:59", endString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
//    NSString *s = [NSString stringWithFormat:@"%@",endString];
    return date;
}

@end
