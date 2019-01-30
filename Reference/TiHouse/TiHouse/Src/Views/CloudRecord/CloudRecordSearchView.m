//
//  CloudRecordSearchView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordSearchView.h"
#import "CloudRecordSearchCell.h"
#import <UIScrollView+EmptyDataSet.h>
// 结果展示
#import "HXPhotoPicker.h"
#import "UIMessageInputView.h"
#import "MoreBtn.h"
#import "TimerTweets.h"
#import "TimerShaftTableViewCell.h"
#import "HouesInfoCell.h"
#import "HouseTweetEditViewController.h"
#import "TweetDetailsViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

static NSString * dataID = @"CloudRecordSearchHistory";

#define kCommentIndexNotFound -1

@interface CloudRecordSearchView ()<CloudRecordSearchCellDelegate, UITextFieldDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIMessageInputViewDelegate, HXAlbumListViewControllerDelegate, HXCustomCameraViewControllerDelegate> {
    CGFloat _oldPanOffsetY;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 最近搜索
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView; // 搜索结果

@property (strong, nonatomic) NSMutableArray * dataArray; // 最近搜索对应的tableView

@property (nonatomic, assign) BOOL isShowEmptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeightLayout;

// 结果展示
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) TimerTweets *timerTweets;
@property (nonatomic, strong) MoreBtn *MoreBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) TweetComment *commentTweet;
@property (nonatomic, assign) NSInteger commentIndex;
@property (nonatomic, strong) UIView *commentSender;
@property (nonatomic, strong) modelDairy *modelDairy;
@property (nonatomic, strong) Dairyzan *zan;

@property (nonatomic, copy) NSString *searchText;
@end

@implementation CloudRecordSearchView
/*
 + (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouse:(House *)house {
 CloudRecordSearchView * cloudRecordSearchView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
 [cloudRecordSearchView xl_setupViews];
 [cloudRecordSearchView xl_bindViewModel];
 
 return cloudRecordSearchView;
 }
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self xl_setupViews];
    [self xl_bindViewModel];
    self.searchBarTopLayout.constant = kDevice_Is_iPhoneX?50:26;
    self.containViewHeightLayout.constant = kDevice_Is_iPhoneX ? 90 : 64;
    [self.textTF becomeFirstResponder];
    [_myMsgInputView prepareToShow];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

-(void)xl_setupViews {
    
    
    self.tableView.tableFooterView = [UIView new];
    self.resultTableView.tableFooterView = [UIView new];
    
//    self.resultTableView.hidden = YES;
    [self showTableView];
    
    self.resultTableView.emptyDataSetDelegate = self;
    self.resultTableView.emptyDataSetSource = self;
    
    [self.resultTableView registerClass:[TimerShaftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_HouesInfo];
    WEAKSELF
    self.resultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf currentMonthreFresh];
    }];
    [self.resultTableView bringSubviewToFront:self.resultTableView.mj_header];
    self.resultTableView.backgroundColor = kRKBViewControllerBgColor;
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resultTableView.showsVerticalScrollIndicator = NO;
    self.resultTableView.estimatedRowHeight = 0;

    
    // 结果展示
    _timerTweets = [[TimerTweets alloc]init];
    _timerTweets.house = _house;
    _timerTweets.canLoadMore = YES;
    
    _myMsgInputView = [UIMessageInputView messageInputView];
    _myMsgInputView.isAlwaysShow = NO;
    _myMsgInputView.delegate = self;
    
    self.textTF.clearButtonMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    //init
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userDefault objectForKey:dataID];
    if (array.count > 0) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

-(void)xl_bindViewModel {
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.dataArray.count;
    }
    return [_timerTweets.ALLlist[section] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.resultTableView) {
        return nil;
    }
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, kScreen_Width, 50);
    
    UILabel * recentLabel = [[UILabel alloc] init];
    recentLabel.font = [UIFont systemFontOfSize:14.f];
    recentLabel.textColor =  [UIColor colorWithRGBHex:0x2D2F35];
    recentLabel.text = @"最近搜索";
    [view addSubview:recentLabel];
    [recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12.5);
        make.bottom.mas_equalTo(1);
    }];
    
    UIButton * delectBtn = [[UIButton alloc] init];
    [delectBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    delectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [delectBtn setTitleColor:[UIColor colorWithRGBHex:0xAAAAAA] forState:UIControlStateNormal];
    delectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [delectBtn addTarget:self action:@selector(clearAllData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:delectBtn];
    [delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(recentLabel.mas_right).offset(0);
        make.right.mas_equalTo(-12.5);
        make.width.mas_equalTo(110);
        make.bottom.mas_equalTo(1);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = XWColorFromHex(0xEBEBEB);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(12.5);
        make.height.mas_equalTo(1);
    }];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return nil;
    }
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    if ([self.timerTweets.ALLlist[0] count] >= 20) {
        return self.MoreBtn;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 50;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 0.01;
    }
    //    if ([_timerTweets.ALLlist.firstObject count] && section == 0) {
    // MARK: - bug fix by Charles Zou (修复bug，需求是要显示20条记录后，才出现加载更多)
    if ([self.timerTweets.ALLlist[0] count] >= 20) {
        return 60;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        return 50;
    }
    
    if (_line) {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(23));
            make.top.equalTo(@(self->_resultTableView.contentSize.height-44));
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        static NSString * cellID = @"CloudRecordSearchCell";
        CloudRecordSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CloudRecordSearchCell" owner:nil options:nil] firstObject];
        }
        cell.delegate = self;
        
        NSString * name = self.dataArray[indexPath.row];
        cell.titleLabel.text = name;
        
        return cell;
    }
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
            [weakSelf.resultTableView reloadData];
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
                [weakSelf.parentVC.navigationController pushViewController:TweetDetailsVC animated:YES];
                
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    if (tableView == self.tableView) {
//        static NSString * cellID = @"CloudRecordSearchCell";
        CloudRecordSearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       self.textTF.text = _searchText = cell.titleLabel.text;
        [self currentMonthreFresh];
    } else {
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
        [self.parentVC.navigationController pushViewController:TweetDetailsVC animated:YES];

    }
}

/**
 * 取消按钮事件
 */
- (IBAction)cancleBtnAction:(UIButton *)sender {
    [self.textTF resignFirstResponder];
    [_myMsgInputView prepareToDismiss];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    [self.cancleBtnSubject sendNext:nil];
}

/**
 * 情况历史数据
 */
-(void)clearAllData {
    [self.dataArray removeAllObjects];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.dataArray forKey:dataID];
    [userDefault synchronize];
    
    [self.tableView reloadData];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // utf-8
    //    NSString *utf8DairyDesc = [textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/pageByDairydesc" withParams:@{@"searchDairydesc": utf8DairyDesc} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
    //        if ([data[@"is"] integerValue]) {
    //            XWLog(@"进行了搜索 %@", data);
    //        }
    //    }];
    _searchText = textField.text;
    [self currentMonthreFresh];
    
    if (![self.dataArray containsObject:textField.text]) {
        [self.dataArray addObject:textField.text];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.dataArray forKey:dataID];
        [userDefault synchronize];
        
        [self.tableView reloadData];
    }
    
    return YES;
}

#pragma mark - CloudRecordSearchCell delegate
-(void)CloudRecordSearchCellDelegateCloseAction:(NSInteger)index {
    
    [self.dataArray removeObjectAtIndex:index];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.dataArray forKey:dataID];
    [userDefault synchronize];
    
    [self.tableView reloadData];
}

#pragma mark - get fun
-(RACSubject *)cancleBtnSubject {
    if (!_cancleBtnSubject) {
        _cancleBtnSubject = [RACSubject subject];
    }
    return _cancleBtnSubject;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"search_e.png"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有找到相关内容，换个词试试吧";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGB(191, 191, 191),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

#pragma mark - lazy
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
        [_resultTableView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(23));
            make.top.equalTo(@(self.resultTableView.contentSize.height));
            make.height.equalTo(@(kScreen_Height));
            make.width.equalTo(@(1));
        }];
    }
    return _line;
}


#pragma mark - search result
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
    NSString *utf8Desc = [_searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet
                                                                                               ]];
    NSDictionary *params = @{@"start": @0, @"limit": @20, @"houseid": @(_house.houseid), @"latesttime": _timerTweets.currentLastTime, @"searchDairydesc": utf8Desc};

    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/logtimeaxis/pageStatus1ByHouseidnew" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        [self endLoading];
        [weakSelf.resultTableView.mj_header endRefreshing];
        [self.MoreBtn.Roud.layer removeAllAnimations];
        if (data) {
            [self showResultTableView];
            NSArray * timerShaft = [TimerShaft mj_objectArrayWithKeyValuesArray:data[@"data"]];
            self.isShowEmptyView = timerShaft.count == 0;
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
        [weakSelf.resultTableView reloadData];
    }];
}

#pragma mark - zan comment
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
            [self.parentVC.navigationController pushViewController:houseTweetEditVC animated:YES];
            houseTweetEditVC.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
                [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithQiNiu:tweet isEdit:YES Block:^(Dairy *data, NSError *error) {
                    if (data) {
                        [NSObject showStatusBarSuccessStr:@"编辑成功"];
                        dairy.dairy = data;
                        [weakSelf.resultTableView reloadData];
                        
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
                [weakSelf.resultTableView reloadData];
            }];
            
        }
    }];
}

-(void)zanClickWithDairyzan:(Dairyzan *)zan isZan:(BOOL)iszan IndexPath:(NSIndexPath *)indexPath modelDairy:(modelDairy *)modelDairy{
    if (!iszan) {
        [modelDairy CancelZan];
        self.resultTableView.scrollEnabled = NO;
        [self.resultTableView reloadData];
        self.resultTableView.scrollEnabled = YES;
    }
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_TimerShaftZanWithDairyzan:zan isZan:iszan Block:^(id data, NSError *error) {
        if (data) {
            if (iszan) {
                [modelDairy ClickZan:(Dairyzan *)data];
            }
            [weakSelf.resultTableView reloadData];
        }
    }];
}

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
            [weakSelf.resultTableView reloadData];
        }
        else{
            [NSOrderedSet showStatusBarErrorStr:@"评论失败！"];
        }
        
    }];
}

#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    _commentTweet.dairycommcontent = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sendCommentMessage:text];
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


// 判断最大日期
- (NSString *)maxTimestamp:(NSArray *)array {
    
    __block NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
    [array enumerateObjectsUsingBlock:^(TweetImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lastDate = [lastDate laterDate:obj.creationDate];
    }];
    return [NSString stringWithFormat:@"%ld", (long)([lastDate timeIntervalSince1970]*1000)] ;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = [notification object];
    if (textField != self.textTF) return;
    
    // 现实联想词
    if ([textField.text length] == 0 ) {
        [self showTableView];
    }
}

-(void)showTableView {
    self.tableView.alpha  = 1.f;
    self.resultTableView.alpha  = 0.f;
    //    self.backLeading.constant = kRKBWIDTH(-34.f);
    //    self.cancelTrailing.constant = -0.f;
    //    [UIView animateWithDuration:0.25 animations:^{
    //        [self.view layoutIfNeeded];
    //    }];
    
    [self.tableView reloadData];
}

-(void)showResultTableView {
    //    self.backView.hidden = NO;
    [self.textTF resignFirstResponder];
    self.resultTableView.alpha = 1.f;
    self.tableView.alpha  = 0.f;
    //    self.backLeading.constant = 0.f;
    //    self.cancelTrailing.constant = kRKBWIDTH(-52.f);
    //    [UIView animateWithDuration:0.25 animations:^{
    //        [self.view layoutIfNeeded];
    //    }];
    
    [self.resultTableView reloadData];
}

@end
