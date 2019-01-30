//
//  HouseInfoViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/19.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HouseInfoViewController.h"
#import "AccountBooksAddViewController.h"
#import "HouseInfoTableHeader.h"
#import "HouesInfoCell.h"
#import "AddHouseViewController.h"
#import "zhFullView.h"
#import "zhIconLabel.h"
#import "zhPopupController.h"
#import "Journal.h"
#import "GuidanceView.h"
#import "UIMessageInputView.h"
#import "HXPhotoPicker.h"
#import "NSDate+Extend.h"
#import "HouseTweet.h"
#import "TOCropViewController.h"
#import "HouseChangeViewController.h"
#import "HouseMoveTweetViewController.h"
#import "BudgetDetailsPreviewViewController.h"
#import "AccountBooksTimeLineViewController.h"
#import "HouseTweetEditViewController.h"
#import "CommentPopView.h"
#import "TimerShaftTableViewCell.h"
#import "TimerShaftBudgetCell.h"
#import "TimerShaftTallysCell.h"
#import "TimerShaftScheduleCell.h"
#import "TimerShaftNoContentCell.h"
#import "TweetMonthCountCell.h"
#import "TimerTweets.h"
#import "modelDairy.h"
#import "Budget.h"
#import "LookTransformViewController.h"
#import "AccountBooksViewController.h"
#import "AccountBooksStaViewController.h"
#import "TweetComment.h"
#import "MoreBtn.h"
#import "SharePopView.h"
#import "TweetDetailsViewController.h"
#import "TweetMonthCountS.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RDVTabBarController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "RelativeAndFriendVC.h"
#import "CloudRecordVC.h"
#import "ScheduleVC.h"
#import "Login.h"
#import "NewBudgetViewController.h"
#import "NewScheduleVC.h"
#import "UIImage+Common.h"
#import "AccountBooksRecordViewController.h"
#import "BudgetListViewController.h"
#import "THAlertView.h"
#import "THHouseMonthViewController.h"
#import "UILabel+Number.h"

#define kTallyID @"traceTallyID"

#define kCommentIndexNotFound -1
// 月份的高度
#define kTreetCell_LinePadingLeft 18.0
#define kTreetMedia_Wtith kScreen_Width - kTreetCell_LinePadingLeft - 11 - 24

static NSInteger coverTapCount = 0;

@interface HouseInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIMessageInputViewDelegate,HXAlbumListViewControllerDelegate,HXCustomCameraViewControllerDelegate,TOCropViewControllerDelegate ,HouseInfoTableHeaderDelegate>
{
    NSMutableArray *items;
    CGFloat _oldPanOffsetY;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HouseInfoTableHeader *tableHeader;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableDictionary *hXPhotoModelDic;
@property (strong, nonatomic) NSMutableArray *TweetArr;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, retain) TOCropViewController *cropController;
@property (nonatomic, retain) TimerTweets *timerTweets;
@property (nonatomic, retain) MoreBtn *MoreBtn;
@property (nonatomic, retain) UIView *line;
@property (nonatomic, strong) UIButton *leftBtn;


//评论
@property (nonatomic, strong) TweetComment *commentTweet;
@property (nonatomic, assign) NSInteger commentIndex;
@property (nonatomic, strong) UIView *commentSender;
@property (nonatomic, strong) modelDairy *modelDairy;
//赞
@property (nonatomic, strong) Dairyzan *zan;
@property (nonatomic, assign) NSInteger allCount;

@end

@implementation HouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第一次进入时间轴的话展示浮层
    if (_house.isFirstCreate) {
        _house.isFirstCreate = NO;
        [self showCoverlayer];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"DeleteByCreator"];
    
    // 日程编辑 更新x
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHouseInfo) name:@"HouseInforelodaData" object:nil];
    // 删除日程
    
    // 账本相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTally:) name:TALLY_RELOAD_NOTIFICATION object:nil];
    
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _hXPhotoModelDic = [NSMutableDictionary dictionary];
    _TweetArr = [NSMutableArray new];
    
    if (!self.house.isedit) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        UIImage *rightImage = [[UIImage imageNamed:@"navBar_Car"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(PopMenus)];
        self.navigationItem.rightBarButtonItem = barBtn1;
    }
    //初始化数据
    _timerTweets = [[TimerTweets alloc]init];
    _timerTweets.house = _house;
    _timerTweets.canLoadMore = YES;
    [self tableView];
    //区头
    [self setHeaderInfo];
    
    _myMsgInputView = [UIMessageInputView messageInputView];
    _myMsgInputView.isAlwaysShow = NO;
    _myMsgInputView.delegate = self;
    [NSObject showHUDQuery];
    [self getHouseInfo];
    
    if (self.isFixNavigation) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self setBackNavWithWhiteColor:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    //键盘
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [_myMsgInputView prepareToShow];
    [_tableView reloadData];
    [(BaseNavigationController *)self.navigationController hideNavBottomLine];
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFixNavigation) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self wr_setNavBarBarTintColor:[UIColor clearColor]];
            [self setBackNavWithWhiteColor:YES];
            [self.navigationController setNavigationBarHidden:NO];
        });
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
}

- (void)showAccountBooks {
    //    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kTallyID];
    AccountBooksViewController *vc = [AccountBooksViewController initWithStoryboard];
    vc.Houseid = self.house.houseid;
    vc.house = self.house;
    //    AccountBooksStaViewController *vc = [[AccountBooksStaViewController alloc] init];
    vc.stopRedirect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_timerTweets.ALLlist.firstObject count] && [_timerTweets.ALLlist.lastObject count]) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    if (![_timerTweets.ALLlist.firstObject count] && ![_timerTweets.ALLlist.lastObject count]) {
    //        return NuDate;
    //    }
    if (_house.numrecord == 0 && [_timerTweets.ALLlist.firstObject count] == 0) {
        return section == 0 ? 1 : 0;
    } else {
        return [_timerTweets.ALLlist[section] count];
    }
    //    return [_timerTweets.ALLlist[section] count] == 0 ? 1 : [_timerTweets.ALLlist[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    if (![_timerTweets.ALLlist.firstObject count] && ![_timerTweets.ALLlist.lastObject count] && _house.numrecord == 0) {
        TimerShaftNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerShaftNoContentCell" forIndexPath:indexPath];
        cell.CellBlockClick = ^{
            [weakSelf PopMenus];
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        TweetMonthCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetMonthCountCell" forIndexPath:indexPath];
        cell.monthDairyModel = _timerTweets.ALLlist[indexPath.section][indexPath.row];
        return cell;
    }
    
    TimerShaft *shaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row];
    TimerShaft *TopshaftCellData;
    if (indexPath.row != 0) {
        TopshaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row-1];
    }
    
    //    日记样式CELL
    if (shaftCellData.type == 1) {
        
        TimerShaftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_HouesInfo forIndexPath:indexPath];
        cell.icon.hidden = TopshaftCellData ? [NSDate isAlikeDay:TopshaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
        modelDairy *dairy = shaftCellData.modelDairy;
        cell.house = _house;
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
                [self clickEdit:dairy];
            }
        };
        //评论回复
        cell.CommentReply = ^(modelDairy *modelDairy, NSInteger row) {
            self->_modelDairy = modelDairy;
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
    //    预算样式cell
    if (shaftCellData.type == 2) {
        TimerShaftBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerShaftBudgetCell" forIndexPath:indexPath];
        cell.icon.hidden = TopshaftCellData ? [NSDate isAlikeDay:TopshaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
        if (shaftCellData.modelBudget.latesttime == 0) {
            shaftCellData.modelBudget.latesttime = shaftCellData.latesttime;
        }
        [cell setmodelTunerBudget:shaftCellData.modelBudget needTopView:indexPath.row == 0 needBottomView: indexPath.row != [_timerTweets.ALLlist[indexPath.section] count]-1];
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        }else{
            cell.icon.image = [UIImage imageNamed:@"timerShaft_icon"];
        }
        cell.CellBlockClick = ^(NSInteger tag) {
            if (tag == 1) {
                Budget *buget = [[Budget alloc]init];
                buget.budgetid = shaftCellData.modelBudget.budgetid;
                buget.budgetname = shaftCellData.modelBudget.budgetname;
                buget.linkshare = shaftCellData.modelBudget.linkshare;
                [weakSelf GoToLookBudgetDetailsPreviewViewControllerWithBudget:buget];
            }else if(tag == 2){
                Budget *buget = [[Budget alloc]init];
                buget.budgetid = shaftCellData.modelBudget.budgetid;
                buget.budgetname = shaftCellData.modelBudget.budgetname;
                [weakSelf GoToLookTransformViewControllerWithBudget:buget];
            }
        };
        return cell;
    }
    //    记账样式cell
    if (shaftCellData.type == 3) {
        TimerShaftTallysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerShaftTallysCell" forIndexPath:indexPath];
        cell.icon.hidden = TopshaftCellData ? [NSDate isAlikeDay:TopshaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
        if (shaftCellData.modelTally.latesttime == 0) {
            shaftCellData.modelTally.latesttime = shaftCellData.latesttime;
        }
        [cell setmodelmodelTallys:shaftCellData.modelTally needTopView:indexPath.row == 0 needBottomView: indexPath.row != [_timerTweets.ALLlist[indexPath.section] count]-1];
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        }else{
            cell.icon.image = [UIImage imageNamed:@"timerShaft_icon"];
        }
        cell.CellBlockClick = ^(NSInteger tag) {
            if (tag == 1) {
                AccountBooksTimeLineViewController *vc = [AccountBooksTimeLineViewController initWithStoryboard];
                vc.Tallyid = shaftCellData.modelTally.tallyid;
                vc.house = self.house;
                User *user = [Login curLoginUser];
                if (user.uid == self.house.uidcreater) {
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:[NSNumber numberWithLong:shaftCellData.modelTally.tallyid] forKey:kTallyID];
                    [userDefault synchronize];
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                AccountBooksRecordViewController *vc = [AccountBooksRecordViewController initWithStoryboard];
                vc.Tallyid = shaftCellData.modelTally.tallyid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
        };
        
        
        return cell;
    }
    //    日程样式cell
    if (shaftCellData.type == 4) {
        TimerShaftScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerShaftScheduleCell" forIndexPath:indexPath];
        cell.icon.hidden = TopshaftCellData ? [NSDate isAlikeDay:TopshaftCellData.latesttime Tow:shaftCellData.latesttime] : NO;
        if (shaftCellData.scheduleMap.latesttime == 0) {
            shaftCellData.scheduleMap.latesttime = shaftCellData.latesttime;
        }
        [cell setmodelTweetScheduleMap:shaftCellData.scheduleMap needTopView:indexPath.row == 0 needBottomView: indexPath.row != [_timerTweets.ALLlist[indexPath.section] count]-1];
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"timerShaft_lock"];
        }else{
            cell.icon.image = [UIImage imageNamed:@"timerShaft_icon"];
        }
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
    //月份统计
    if (indexPath.section == 1) {
        return 110 + (kTreetMedia_Wtith - 34) / 3;
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
    if (shaftCellData.type == 2) {
        return [TimerShaftBudgetCell cellHeightWithTunerBudget:shaftCellData.modelBudget needTopView:indexPath.row == 0 needBottomView:!needBottomView];
    }
    if (shaftCellData.type == 3) {
        return [TimerShaftTallysCell cellHeightWithmodelTallys:shaftCellData.modelTally needTopView:indexPath.row == 0 needBottomView:!needBottomView];
    }
    if (shaftCellData.type == 4) {
        return [TimerShaftScheduleCell cellHeightWithTweetScheduleMap:shaftCellData.scheduleMap needTopView:indexPath.row == 0 needBottomView:!needBottomView];
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_timerTweets.ALLlist[indexPath.section] count] == 0) {
        return;
    }
    if (indexPath.section == 1) {
        [self pushToMonthDetail:indexPath.row];
        return;
    }
    
    TimerShaft *shaftCellData = _timerTweets.ALLlist[indexPath.section][indexPath.row];
    if (shaftCellData.type == 1) {
        TweetDetailsViewController *TweetDetailsVC = [[TweetDetailsViewController alloc]init];
        TweetDetailsVC.modelDairy = shaftCellData.modelDairy;
        TweetDetailsVC.house = _house;
        TweetDetailsVC.title = _house.housename;
        [TweetDetailsVC setRelodaDataCallback:^{
            [self currentMonthresendRequest];
        }];
        [self.navigationController pushViewController:TweetDetailsVC animated:YES];
    }
    if (shaftCellData.type == 4) {
        NewScheduleVC *nsVC = [[NewScheduleVC alloc] init];
        nsVC.house = self.house;
        ScheduleModel *M = [[ScheduleModel alloc]init];
        [M setValuesForKeysWithDictionary:[shaftCellData.scheduleMap.schedule mj_keyValues]];
        nsVC.scheduleM = M;
        nsVC.house = _house;
        nsVC.refreshBlock = ^() {
            [self removeCurrentSchedule:shaftCellData];
        };
        [self.navigationController pushViewController:nsVC animated:YES];
    }
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    //    if ([self.timerTweets.ALLlist[0] count] >= 20 && section == 0) {
    if ((_allCount > 20 || [self.timerTweets.ALLlist[0] count] > 20) && section == 0) {
        return 60;
    }
    return 0.01;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    //    if ([self.timerTweets.ALLlist[0] count] >= 20 && section == 0) {
    if ((_allCount > 20 || [self.timerTweets.ALLlist[0] count] > 20) && section == 0) {
        return self.MoreBtn;
    }
    return nil;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    if (-contentOffsety > 100) {
        _tableView.contentOffset = CGPointMake(0, -100);
    }
    
    //NavBar背景色渐变
    [self wr_setNavBarBarTintColor:XWColorFromHexAlpha(0xfdf086,(contentOffsety-165)/10.0)];
    if (contentOffsety < 175) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        self.title = @"";
        [self setBackNavWithWhiteColor:YES];
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self wr_setNavBarTintColor:kRKBNAVBLACK];
        self.title = _house.housename;
        [self setBackNavWithWhiteColor:NO];
    }
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


#pragma mark - CustomDelegate
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAKSELF
    if (weakSelf.manager.configuration.singleSelected && weakSelf.manager.type == HXPhotoManagerSelectedTypePhoto) {
        HXPhotoModel *model = photoList.firstObject;
        weakSelf.tableHeader.icon.image = model.previewPhoto;
        weakSelf.house.front = model.previewPhoto;
        weakSelf.house.halfurlfront = @"";
        [self saveIcon];
        return;
    }
    //清除上次选择
    [_hXPhotoModelDic removeAllObjects];
    if (photoList.count > 0) {
        //遍历照片判断是否是不同日期的
        [photoList enumerateObjectsUsingBlock:^(HXPhotoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *arr = [weakSelf.hXPhotoModelDic objectForKey:[obj.creationDate ymdFormat]]; // 这里要用ymd，因为要按天拆分
            if (arr) {
                PHAsset *asset = obj.asset;
                if (asset) {
                    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                    // 同步获得图片, 只会返回1张图片
                    options.synchronous = YES;
                    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
                        image.image = original ? result : [result zipCompress:0.1];
                        image.beforeModel = obj;
                        image.creationDate = obj.creationDate;
                        [arr addObject:image];
                    }];
                }else{
                    TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
                    image.image = obj.previewPhoto;
                    image.beforeModel = obj;
                    image.creationDate = obj.creationDate;
                    [arr addObject:image];
                }
            }else{
                PHAsset *asset = obj.asset;
                if (asset) {
                    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                    options.synchronous = YES;
                    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        NSMutableArray *newArr = [NSMutableArray new];
                        TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
                        image.image = original ? result : [result zipCompress:0.1];
                        image.beforeModel = obj;
                        image.creationDate = obj.creationDate;
                        [newArr addObject:image];
                        [weakSelf.hXPhotoModelDic setObject:newArr forKey:[obj.creationDate ymdFormat]]; // 这里要用ymd，因为要按天拆分
                    }];
                }else{
                    NSMutableArray *newArr = [NSMutableArray new];
                    TweetImage *image = [TweetImage tweetImageWithAsset:obj.asset];
                    image.image = obj.previewPhoto;
                    image.beforeModel = obj;
                    image.creationDate = obj.creationDate;
                    [newArr addObject:image];
                    [weakSelf.hXPhotoModelDic setObject:newArr forKey:[obj.creationDate ymdFormat]]; // 这里要用ymd，因为要按天拆分
                }
            }
        }];
        [_TweetArr removeAllObjects];
        [_hXPhotoModelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            HouseTweet *tweet = [[HouseTweet alloc]init];
            tweet.type = TweetTypePhoto;
            tweet.images = obj;
            tweet.house = weakSelf.house;
            tweet.dairytimetype = 1; // 照片默认是拍摄时间类型
            // 这里对imgaes里的TweetImage的creationDate进行排序
            if (tweet.images.count == 1) {
                tweet.createData = [NSString stringWithFormat:@"%ld", (long)([[tweet.images[0] creationDate] timeIntervalSince1970]*1000)] ;
            } else {
                // 遍历排序
                tweet.createData = [self maxTimestamp:tweet.images];
            }
            [weakSelf.TweetArr addObject:tweet];
        }];
        if (_TweetArr && _TweetArr.count == 1) {
            HouseChangeViewController *houseChange = [[HouseChangeViewController alloc]init];
            houseChange.tweet = _TweetArr.firstObject;
            houseChange.manager = _manager;
            houseChange.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
                
                NSInteger index = [weakSelf.timerTweets addTweet:tweet];
                
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                
                // MARK: - 发布
                [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithQiNiu:tweet isEdit:NO Block:^(Dairy *data, NSError *error) {
                    if (!data) {
                        [weakSelf.timerTweets.currentMonthlist removeObjectAtIndex:index];
                        [weakSelf.tableView reloadData];
                    } else {
                        TimerShaft *timerShaft = [weakSelf.timerTweets.currentMonthlist objectAtIndex:index];
                        timerShaft.modelDairy.dairy = data;
                        [weakSelf.tableView reloadData];
                    }
                }];
            };
            [self.navigationController pushViewController:houseChange animated:NO];
        }else if(_TweetArr && _TweetArr.count > 1){ // 如果新建图片不止一个图片时要判断是否拆分
            
            [THAlertView showAlert:@"提示" message:@"是否拆分按照日期上传?" cancelTitle:@"合并" clickCancel:^{
                HouseTweet *tweet = [[HouseTweet alloc]init];
                tweet.type = TweetTypePhoto;
                [weakSelf.hXPhotoModelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [tweet.images addObjectsFromArray:obj];
                }];
                tweet.house = weakSelf.house;
                // 遍历排序
                tweet.createData = [self maxTimestamp:tweet.images];
                
                HouseChangeViewController *houseChange = [[HouseChangeViewController alloc]init];
                houseChange.tweet = tweet;
                houseChange.manager = weakSelf.manager;
                houseChange.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
                    NSInteger index = [weakSelf.timerTweets addTweet:tweet];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    // MARK: - 发布
                    [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithQiNiu:tweet isEdit:NO Block:^(Dairy *data, NSError *error) {
                        if (data) {
                            TimerShaft *timerShaft = [weakSelf.timerTweets.currentMonthlist objectAtIndex:index];
                            timerShaft.modelDairy.dairy = data;
                            [weakSelf.tableView reloadData];
                        } else {
                            [weakSelf.timerTweets.currentMonthlist removeObjectAtIndex:index];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                };
                [self.navigationController pushViewController:houseChange animated:NO];
                [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
                
            } otherTitle:@"拆分" clickOther:^{
                
                HouseMoveTweetViewController *houseChange = [[HouseMoveTweetViewController alloc]init];
                houseChange.manager = weakSelf.manager;
                houseChange.tweets = weakSelf.TweetArr;
                houseChange.sendTweet = ^(NSArray *tweets) {
                    //多条数据
                    if (tweets.count > 1) {
                        NSInteger index = [weakSelf.timerTweets addTweet:tweets.lastObject];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        [tweets enumerateObjectsUsingBlock:^(HouseTweet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithTweet:obj isEdit:NO Block:^(id data, NSError *error) {
                                
                                if (idx == tweets.count-1) {
                                    [NSObject hideHUDQuery];
                                    if (data) {
                                        [weakSelf currentMonthresendRequest];
                                    }
                                }
                            }];
                        }];
                    } else {
                        NSInteger index = [weakSelf.timerTweets addTweet:tweets[0]];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithTweet:tweets.firstObject isEdit:NO Block:^(id data, NSError *error) {
                            [NSObject hideHUDQuery];
                            if (data) {
                                [weakSelf currentMonthresendRequest];
                            }
                        }];
                    }
                };
                
                [self.navigationController pushViewController:houseChange animated:NO];
                [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
            }];
        }
    }else if (videoList.count > 0) {
        HXPhotoModel *model = videoList.firstObject;
        HouseTweet *tweet = [[HouseTweet alloc]init];
        TweetImage *image = [TweetImage tweetImageWithAssetURL:model.videoURL andImage:model.previewPhoto];
        tweet.type = TweetTypeVideo;
        tweet.createData = [model.asset.creationDate msecFormatter];
        image.creationDate = model.asset.creationDate ? : [NSDate date];
        tweet.url = model.videoURL;
        tweet.house = weakSelf.house;
        [tweet.images addObject:image];
        [weakSelf.TweetArr addObject:tweet];
        HouseChangeViewController *houseChange = [[HouseChangeViewController alloc]init];
        houseChange.isVideo = YES;
        houseChange.tweet = tweet;
        houseChange.manager = _manager;
        houseChange.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
            NSInteger index = [weakSelf.timerTweets addTweet:tweet];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetVidoWithTweet:tweet isEdit:NO Block:^(id data, NSError *error) {
                
                if (data) {
                    TimerShaft *timerShaft = [weakSelf.timerTweets.currentMonthlist objectAtIndex:index];
                    timerShaft.modelDairy.dairy = data;
                    [weakSelf.tableView reloadData];
                    
                } else {
                    [weakSelf.timerTweets.currentMonthlist removeObjectAtIndex:index];
                    [weakSelf.tableView reloadData];
                }
            }];
        };
        [self.navigationController pushViewController:houseChange animated:NO];
    }
    [self.manager clearSelectedList];
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    _tableHeader.icon.image = image;
    _house.front = image;
    _house.halfurlfront = @"";
    [self saveIcon];
    [cropViewController.navigationController popViewControllerAnimated:YES];
}

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    
    [self.navigationController pushViewController:_cropController animated:NO];
}


-(void)saveIcon{
    WEAKSELF
    [NSObject showStatusBarQueryStr:@"正在修改头像...."];
    [[TiHouse_NetAPIManager sharedManager]request_EditHouseWithHouse:_house Block:^(id data, NSError *error) {
        if (data) {
            weakSelf.house = [House mj_objectWithKeyValues:data[@"data"]];
            weakSelf.house.halfurlfront = [[weakSelf.house.urlfront componentsSeparatedByString:@"com"] lastObject];
            weakSelf.house.halfurlback = [[weakSelf.house.urlback componentsSeparatedByString:@"com"] lastObject];
            weakSelf.house.edit = YES;
            [NSObject showStatusBarSuccessStr:@"修改成功！"];
        }else{
            [NSObject showStatusBarSuccessStr:@"修改失败！"];
        }
    }];
    
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    
    _commentTweet.dairycommcontent = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sendCommentMessage:text];
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
    
    //    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    //        UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, MAX(CGRectGetHeight(inputView.frame), heightToBottom), 0.0);;
    //        CGFloat msgInputY = kScreen_Height - heightToBottom - 64;
    ////
    //        self.tableView.contentInset = contentInsets;
    //        self.tableView.scrollIndicatorInsets = contentInsets;
    //
    //        if ([_commentSender isKindOfClass:[UIView class]] && !self.tableView.isDragging && heightToBottom > 60) {
    //            UIView *senderView = _commentSender;
    //            CGFloat senderViewBottom = [_tableView convertPoint:CGPointZero fromView:senderView].y+ CGRectGetMaxY(senderView.bounds);
    //            CGFloat contentOffsetY = MAX(0, senderViewBottom- msgInputY);
    //            [self.tableView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
    //        }
    //    } completion:nil];
}

#pragma mark Comment To Tweet
- (void)sendCommentMessage:(id)obj{
    if (_commentIndex >= 0) {
    }else{
    }
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

-(void)getHouseInfo{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager]request_HouseInfoWithPath:@"api/inter/house/get" Params:@{@"houseid":[NSString stringWithFormat:@"%ld",_house.houseid]} Block:^(id data, NSError *error) {
        if (data) {
            weakSelf.house = data;
            weakSelf.house.edit = YES;
            weakSelf.house.halfurlfront = [[weakSelf.house.urlfront componentsSeparatedByString:@"com"] lastObject];
            weakSelf.house.halfurlback = [[weakSelf.house.urlback componentsSeparatedByString:@"com"] lastObject];
            [weakSelf setHeaderInfo];
            //    获取数据
            [weakSelf currentMonthreFresh];
            [weakSelf MonthreFresh];
            //未读数
            weakSelf.tableHeader.house = weakSelf.house;
            if (!self.house.isedit) {
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                UIImage *rightImage = [[UIImage imageNamed:@"navBar_Car"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(PopMenus)];
                self.navigationItem.rightBarButtonItem = barBtn1;
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [NSObject hideHUDQuery];
        }
    }];
}

-(void)HouseInfoTableMuneSelected:(HouseInfoTableHeader *)header Index:(NSInteger)index{
    if (index == 0) {
        BudgetDetailsPreviewViewController *budgerVC = [[BudgetDetailsPreviewViewController alloc]init];
        budgerVC.house = _house;
        [self.navigationController pushViewController:budgerVC animated:YES];
    }
    if (index == 1) {
        [self showAccountBooks];
    }
    if (index == 2) {
        //日程
        [self pushToScheduleController];
    }
    if (index == 3) {
        //云记录
        [self pushToCloudReordController];
    }
    if (index == 4) {
        //亲友
        [self pushToRelaticeAndFriendController];
    }
}

-(void)GoToLookTransformViewControllerWithBudget:(Budget *)budget {
    LookTransformViewController *LookTVC = [[LookTransformViewController alloc]init];
    LookTVC.bugset = budget;
    [self.navigationController pushViewController:LookTVC animated:YES];
}

-(void)GoToLookBudgetDetailsPreviewViewControllerWithBudget:(Budget *)budget {
    BudgetDetailsPreviewViewController *budgerVC = [[BudgetDetailsPreviewViewController alloc]init];
    budgerVC.budget = budget;
    budgerVC.house = _house;
    [self.navigationController pushViewController:budgerVC animated:YES];
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

-(void)setHeaderInfo{
    self.tableHeader.estate.text = _house.residentname;
    _tableHeader.nameStr = _house.housename;
    [_tableHeader.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_house.urlback] placeholderImage:_house.back];
    [_tableHeader.icon sd_setImageWithURL:[NSURL URLWithString:_house.urlfront] placeholderImage:_house.front];
    if (_house.uidcreater != [[Login curLoginUser] uid]) {
        _tableHeader.editBtn.hidden = YES;
    } else {
        _tableHeader.editBtn.hidden = NO;
    }
}

-(void)PopMenus{
    
    WEAKSELF
    zhFullView *full = [self fullView];
    full.didClickFullView = ^(zhFullView * _Nonnull fullView) {
        [self.zh_popupController dismiss];
    };
    full.didClickItems = ^(zhFullView *fullView, NSInteger index) {
        
        switch (index) {
            case 0:
            {
                weakSelf.manager.type = HXPhotoManagerSelectedTypePhoto;
                weakSelf.manager.configuration.photoMaxNum = 20;
                weakSelf.manager.configuration.videoMaxNum = 0;
                weakSelf.manager.configuration.maxNum = 20;
                weakSelf.manager.configuration.singleSelected = NO;//是否单选
                [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
            }
                break;
            case 1:
            {
                weakSelf.manager.type = HXPhotoManagerSelectedTypeVideo;
                weakSelf.manager.configuration.photoMaxNum = 0;
                weakSelf.manager.configuration.videoMaxNum = 1;
                weakSelf.manager.configuration.maxNum = 1;
                weakSelf.manager.configuration.singleSelected = YES;//是否单选
                [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
            }
                break;
            case 2:
            {
                [self sendText];
            }
                break;
            case 3:
            {
                BudgetDetailsPreviewViewController *budgerVC = [[BudgetDetailsPreviewViewController alloc]init];
                budgerVC.house = self->_house;
                [self.navigationController pushViewController:budgerVC animated:YES];
            }
                break;
            case 4:
            {
                [self showAccountBooks];
            }
                break;
            case 5:
            {
                [self pushToScheduleController];
            }
                break;
            default:
                break;
        };
        
        self.zh_popupController.didDismiss = ^(zhPopupController * _Nonnull popupController) {
        };
        [fullView endAnimationsCompletion:^(zhFullView *fullView) {
            [self.zh_popupController dismiss];
        }];
    };
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeWhiteBlur];
    self.zh_popupController.allowPan = YES;
    [self.zh_popupController presentContentView:full];
}

-(void)selectImage{
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.manager.type = HXPhotoManagerSelectedTypePhoto;
        weakSelf.manager.configuration.singleSelected = YES;//是否单选
        weakSelf.manager.configuration.ToCarpPresetSquare = YES;
        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf GoToCameraView];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//前往相机
-(void)GoToCameraView{
    WEAKSELF
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
                vc.delegate = weakSelf;
                vc.manager = weakSelf.manager;
                HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
                nav.isCamera = YES;
                nav.supportRotation = self.manager.configuration.supportRotation;
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle hx_localizedStringForKey:@"无法使用相机"] message:[NSBundle hx_localizedStringForKey:@"请在设置-隐私-相机中允许访问相机"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"取消"] style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"设置"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
    
}

- (zhFullView *)fullView {
    
    zhFullView *fullView = [[zhFullView alloc] initWithFrame:self.view.frame];
    NSArray *masterArray = @[@"照片", @"视频", @"日记", @"预算", @"记账", @"日程"];
    NSArray *unMasterArray = @[@"照片", @"视频", @"日记"];
    NSArray *imagesArray = @[@"photo_sw", @"video_sw", @"diary_sw", @"budget_sw", @"account_sw", @"schedule_sw"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity: self.house.uidcreater == [Login curLoginUserID] ?masterArray.count : unMasterArray.count];
    for (NSString *string in self.house.uidcreater == [Login curLoginUserID] ? masterArray : unMasterArray) {
        zhIconLabelModel *item = [zhIconLabelModel new];
        item.text = string;
        [models addObject:item];
    }
    for (NSInteger i = 0; i < models.count; i++) {
        zhIconLabelModel *model = models[i];
        model.icon = [UIImage imageNamed:imagesArray[i]];
    }
    fullView.models = models;
    
    return fullView;
}

#pragma mark - private methods 私有方法
- (void)currentMonthreFresh{
    
    if (_timerTweets.currentMonthisLoading) {
        return;
    }
    _timerTweets.currentMonthwillLoadMore = NO;
    [_MoreBtn.moreBtn setTitle:@"加载更多" forState:(UIControlStateNormal)];
    _timerTweets.currentLastTime = @(-1);
    [self currentMonthresendRequest];
}

- (void)currentMonthreFreshMore{
    
    if (!_timerTweets.currentMonthCanLoadMore) {
        [_MoreBtn.moreBtn setTitle:@"没有更多了！" forState:(UIControlStateNormal)];
        return;
    }
    
    _timerTweets.currentMonthwillLoadMore = YES;
    modelDairy *lastModelDairy =  [[_timerTweets.ALLlist[0] lastObject] modelDairy];
    _timerTweets.currentLastTime = @(lastModelDairy.dairy.dairytime);
    [_MoreBtn.Roud.layer addSublayer:[MoreBtn replicatorLayer_Round]];
    [self currentMonthresendRequest];
}

-(void)currentMonthresendRequest{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftWithTimerTweets:_timerTweets Block:^(id data, NSInteger allCount, NSError *error) {
        if (data) {
            [weakSelf.timerTweets configWithCurrentMonth:(NSArray *)data];
            [weakSelf line];
            [weakSelf.tableView reloadData];
            weakSelf.timerTweets.currentMonthCanLoadMore = [(NSArray *)data count] < allCount;
            _allCount = allCount;
        }else{
            weakSelf.timerTweets.currentMonthCanLoadMore = NO;
            [weakSelf line];
            [weakSelf.tableView reloadData];
            _allCount = allCount;
        }
        [NSObject hideHUDQuery];
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.MoreBtn.Roud.layer removeAllAnimations];
        
    }];
}

- (void)MonthreFresh{
    
    if (_timerTweets.isLoading) {
        return;
    }
    _timerTweets.willLoadMore = NO;
    _timerTweets.monthpage = @(-1);
    [self MonthresendRequest];
}

- (void)MonthreFreshMore{
    if (_timerTweets.willLoadMore || !_timerTweets.canLoadMore) {
        return;
    }
    _timerTweets.currentMonthwillLoadMore = YES;
    _timerTweets.monthpage = @([_timerTweets.monthpage intValue]-1);
    [self MonthresendRequest];
}

-(void)MonthresendRequest{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftMonthWithTimerTweets:_timerTweets Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf.timerTweets configWithMonthlist:data];
        }
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
        _tableView.tableHeaderView = self.tableHeader;
        [_tableView registerClass:[TimerShaftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_HouesInfo];
        [_tableView registerClass:[TimerShaftBudgetCell class] forCellReuseIdentifier:@"TimerShaftBudgetCell"];
        [_tableView registerClass:[TimerShaftTallysCell class] forCellReuseIdentifier:@"TimerShaftTallysCell"];
        [_tableView registerClass:[TimerShaftScheduleCell class] forCellReuseIdentifier:@"TimerShaftScheduleCell"];
        [_tableView registerClass:[TimerShaftNoContentCell class] forCellReuseIdentifier:@"TimerShaftNoContentCell"];
        [_tableView registerClass:[TweetMonthCountCell class] forCellReuseIdentifier:@"TweetMonthCountCell"];
        _tableView.height = _tableView.height-CGRectGetHeight(self.rdv_tabBarController.tabBar.frame);
        
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = YES;
            _tableView.estimatedRowHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getHouseInfo];
        }];
        [_tableView bringSubviewToFront:_tableView.mj_header];
    }
    return _tableView;
}

-(HouseInfoTableHeader *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[HouseInfoTableHeader alloc]init];
        _tableHeader.delegate = self;
        _tableHeader.frame = CGRectMake(0, 0, kScreen_Width, IphoneX ? 225 : 200);
        WEAKSELF
        _tableHeader.editBlock = ^{
            AddHouseViewController *addHouse = [AddHouseViewController new];
            addHouse.edit = YES;
            addHouse.addHouse = NO;
            weakSelf.house.edit = YES;
            weakSelf.house.halfurlfront = [[weakSelf.house.urlfront componentsSeparatedByString:@"com"] lastObject];
            weakSelf.house.halfurlback = [[weakSelf.house.urlback componentsSeparatedByString:@"com"] lastObject];
            addHouse.myHouse = weakSelf.house;
            
            addHouse.editBlock = ^(House *house) {
                weakSelf.house = house;
                [weakSelf setHeaderInfo];
            };
            [weakSelf.navigationController pushViewController:addHouse animated:YES];
        };
        _tableHeader.iconBlock = ^{
            if (self->_house.houseisself != 1) {
                return;
            }
            weakSelf.manager.configuration.movableCropBox = YES;
            [weakSelf selectImage];
        };
    }
    return _tableHeader;
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
            make.top.equalTo(@(self->_tableView.contentSize.height));
            make.height.equalTo(@(kScreen_Height));
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}

#pragma mark - push vc action
-(void)pushToScheduleController {
    ScheduleVC * schedule = [[ScheduleVC alloc] init];
    schedule.house = self.house;
    [schedule setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:schedule animated:YES];
}

-(void)pushToCloudReordController {
    CloudRecordVC * cloudRecord = [[CloudRecordVC alloc] init];
    cloudRecord.house = self.house;
    [cloudRecord setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cloudRecord animated:YES];
}

-(void)pushToRelaticeAndFriendController {
    RelativeAndFriendVC * relativeAndFriend = [[RelativeAndFriendVC alloc] init];
    relativeAndFriend.house = self.house;
    
    [relativeAndFriend setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:relativeAndFriend animated:YES];
}

- (void)setBackNavWithWhiteColor:(BOOL)isWhite {
    
    if (self.leftBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@" 房屋" forState:UIControlStateNormal];
        [btn setTitleColor:isWhite ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 50, 32);
        [btn setImage:[UIImage imageNamed:isWhite ? @"mine_back_white" : @"account_nav_back"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        self.leftBtn = btn;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
    }
    
    [self.leftBtn setTitleColor:isWhite ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:isWhite ? @"mine_back_white" : @"account_nav_back"] forState:UIControlStateNormal];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCoverlayer {
    UIImageView *coverImageView = [[UIImageView alloc] init];
    [kKeyWindow addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(kKeyWindow);
    }];
    coverImageView.image = [UIImage imageNamed:[UIHelp getCoverImages][coverTapCount]];
    coverImageView.tag = 50001;
    coverImageView.userInteractionEnabled = YES;
    coverTapCount++;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [coverImageView addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    if (coverTapCount > 4) {
        coverTapCount = 0;
        [imageView removeFromSuperview];
    } else {
        imageView.image = [UIImage imageNamed:[UIHelp getCoverImages][coverTapCount]];
        coverTapCount++;
    }
}

// 判断最大日期
- (NSString *)maxTimestamp:(NSArray *)array {
    
    __block NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
    [array enumerateObjectsUsingBlock:^(TweetImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lastDate = [lastDate laterDate:obj.creationDate];
    }];
    return [NSString stringWithFormat:@"%ld", (long)([lastDate timeIntervalSince1970]*1000)] ;
}

// 进入月份时间轴页面
- (void)pushToMonthDetail:(NSInteger)index {
    THHouseMonthViewController *monthVC = [[THHouseMonthViewController alloc] init];
    monthVC.hidesBottomBarWhenPushed = YES;
    MonthDairyModel *model = _timerTweets.ALLlist[1][index];
    monthVC.title = [NSString stringWithFormat:@"%@月",model.dairymonth];
    monthVC.model = model;
    monthVC.house = _house;
    [self.navigationController pushViewController:monthVC animated:YES];
}

- (void)clickEdit:(modelDairy *)dairy {
    WEAKSELF;
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":@(dairy.dairy.dairyid)} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            Dairy *newDairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
            HouseTweet *tweet = [[HouseTweet alloc]init];
            tweet.dairydesc = newDairy.dairydesc;
            tweet.type = newDairy.dairytype;
            tweet.dairytimetype =newDairy.dairytimetype;
            tweet.dairyrangeJAstr = newDairy.dairyrangeJA;
            tweet.dairyremindJAstr = newDairy.dairyremindJA;
            tweet.house = _house;
            tweet.dairy = dairy;
            tweet.diytime = [NSString stringWithFormat:@"%ld",dairy.dairy.diytime];
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

// 发送日记
- (void)sendText {
    WEAKSELF;
    [weakSelf.TweetArr removeAllObjects];
    HouseTweet *tweet = [[HouseTweet alloc]init];
    tweet.type = TweetTypeText;
    tweet.house = weakSelf.house;
    [weakSelf.TweetArr addObject:tweet];
    [weakSelf.manager clearSelectedList];
    weakSelf.manager.configuration.photoMaxNum = 20;
    weakSelf.manager.configuration.videoMaxNum = 0;
    weakSelf.manager.configuration.maxNum = 20;
    weakSelf.manager.configuration.singleSelected = NO;//是否单选
    weakSelf.manager.type = HXPhotoManagerSelectedTypePhoto;
    HouseChangeViewController *houseChange = [[HouseChangeViewController alloc]init];
    houseChange.isDiary = YES;
    houseChange.tweet = weakSelf.TweetArr.firstObject;
    houseChange.manager = weakSelf.manager;
    houseChange.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
        NSInteger index = [weakSelf.timerTweets addTweet:tweet];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithTweet:tweet isEdit:NO Block:^(Dairy *data, NSError *error) {
            if (data) {
                [weakSelf.manager clearSelectedList];
                TimerShaft *timerShaft = [weakSelf.timerTweets.currentMonthlist objectAtIndex:index];
                timerShaft.modelDairy.dairy = data;
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.timerTweets.currentMonthlist removeObjectAtIndex:index];
                [weakSelf.tableView reloadData];
            }
        }];
    };
    [weakSelf.navigationController pushViewController:houseChange animated:YES];
}

- (void)removeCurrentSchedule:(TimerShaft *)shaftData {
    [self.timerTweets.currentMonthlist enumerateObjectsUsingBlock:^(TimerShaft  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.scheduleMap isEqual:shaftData.scheduleMap]) {
            [self.timerTweets.currentMonthlist removeObject:shaftData];
            [self.tableView reloadData];
        }
    }];
}

- (void)reloadTally:(NSNotification *)not {
    
    TimerShaft *tallyShaft = (TimerShaft *)not.object;
    [self.timerTweets.ALLlist.firstObject enumerateObjectsUsingBlock:^(TimerShaft *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.modelTally.tallyid == tallyShaft.modelTally.tallyid) {
            if (![not.userInfo[@"isEdit"] boolValue]) {
                // 如果不是账本编辑操作则删除
                [self.timerTweets.ALLlist.firstObject removeObject:obj];
            } else {
                // 如果是账本编辑相关操作则替换
                NSInteger index = [self.timerTweets.ALLlist.firstObject indexOfObject:obj];
                [self.timerTweets.ALLlist.firstObject replaceObjectAtIndex:index withObject:tallyShaft];
            }
        }
    }];
    if (![not.userInfo[@"isEdit"] boolValue] && ![not.userInfo[@"isDelete"] boolValue] ) {
        [self.timerTweets.ALLlist.firstObject insertObject:tallyShaft atIndex:0];
    }
    [_tableView reloadData];
}
@end



