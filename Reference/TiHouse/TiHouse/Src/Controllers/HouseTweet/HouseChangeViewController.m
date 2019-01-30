//
//  HouseChangeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseChangeViewController.h"
#import "AddHouseTableViewCell.h"
#import "HouseTweetTableViewCell.h"
#import "HouseChangeHeaderView.h"
#import "SelectFileViewController.h"
#import "FriendsRangeViewController.h"
#import "SelectFriendsViewController.h"
#import "SelectRecordingTimeViewController.h"
#import "Folder.h"
#import "HouseTweet.h"
#import "HXPhotoManager.h"
#import "Login.h"
#import "VideoTtimmerViewController.h"

@interface HouseChangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, retain) HouseChangeHeaderView *tableViewHeaderView;
@property (nonatomic, retain) HouseTweet *newtweet;
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray *friends;

@end

@implementation HouseChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房屋新变化";
    // Do any additional setup after loading the view.
    _newtweet = [[HouseTweet alloc]init];
    _newtweet.visibleFriends = _tweet.visibleFriends;
    _newtweet.visibleArr = _tweet.visibleArr;
    _newtweet.remindArr = _tweet.remindArr;
    _newtweet.remindFriends = _tweet.remindFriends;
    _newtweet.visibleRange  = 3;
    _newtweet.dairytimetype = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] animated:YES];
    [HouseTweet convertVideoWithModel:_tweet];
    //获取好友
    if (!_tweet.visibleFriends && !_tweet.remindFriends) {
        [self getFriends];
    }
    _UIModels = _tweet.UIModels.count ? _tweet.UIModels : [UIHelp getHouseChangeUI];
    [self tableView];
    
    [[TiHouse_NetAPIManager sharedManager] request_FilesBlockWith:_tweet.house Block:^(id data, NSError *error) {
        [self.view endLoading];
        if (data) {
            NSArray *dataArray = (NSArray *)data;
            for (Folder *folder in dataArray) {
                if (folder.foldertype == 1) {
                    _tweet.folder = folder;
                }
            }
        }
    }];
    
    self.friends = [[NSMutableArray alloc] init];
    [[TiHouse_NetAPIManager sharedManager] request_FindersWithHouse:_tweet.house Block:^(id data, NSError *error) {
        self.friends = [User mj_objectArrayWithKeyValuesArray:data];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
-(void)finish{
    [self.view endEditing:YES];
    
    _tweet.UIModels = _UIModels;
    _tweet.dairydesc = _newtweet.dairydesc.length <= 0 ? _tweet.dairydesc : _newtweet.dairydesc;
    _tweet.images = _newtweet.images.count ? _newtweet.images : _tweet.images;
    _tweet.createData = _newtweet.createData.length <= 0 ? _tweet.createData : _newtweet.createData;
    _tweet.dateIndex = _newtweet.dateIndex;
    _tweet.folder = _newtweet.folder ? _newtweet.folder : _tweet.folder;
    _tweet.folders = _newtweet.folders ? _newtweet.folders : _tweet.folders;
    _tweet.remindArr = _newtweet.remindArr ? _newtweet.remindArr : _tweet.remindArr;
    _tweet.remindFriends = _newtweet.remindFriends ? _newtweet.remindFriends : _tweet.remindFriends;
    _tweet.visibleArr = _newtweet.visibleArr ? _newtweet.visibleArr : _tweet.visibleArr;
    _tweet.visibleFriends = _newtweet.visibleFriends ? _newtweet.visibleFriends : _tweet.visibleFriends;
    _tweet.visibleRange = _newtweet.visibleRange ? _newtweet.visibleRange :_tweet.visibleRange;
    _tweet.dairytimetype = _newtweet.dairytimetype ? _newtweet.dairytimetype : _tweet.dairytimetype;
    // 如果不指定时间且是纯文本时dairytimetype为2，当前时间
    if (_tweet.dairytimetype != 3 && _tweet.images.count == 0) _tweet.dairytimetype = 2;
    // 新接口
    _tweet.diytime = _newtweet.diytime ? _newtweet.diytime : _tweet.diytime;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    BOOL is4G = [manager isReachableViaWWAN];
    BOOL isWifi = [manager isReachableViaWiFi];
    if (_isVideo && [Login curLoginUser].useriswifi && is4G && !isWifi) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前非Wifi环境，是否继续使用4G?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_sendTweet) {
                _sendTweet(_tweet, NO);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:continueAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if (_sendTweet) {
            _sendTweet(_tweet, NO);
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //多条数据
    //    if (_TweetArr.count > 1) {
    //        [_TweetArr enumerateObjectsUsingBlock:^(HouseTweet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            [[TiHouse_NetAPIManager sharedManager] request_addHouseTweetWithTweet:obj Block:^(id data, NSError *error) {
    //                if (idx == _TweetArr.count-1) {
    //                    [NSObject hideHUDQuery];
    //                    if ([data integerValue]) {
    //                        [NSObject showHudTipStr:@"发布成功！"];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [_manager clearSelectedList];
    //                            [self.navigationController popViewControllerAnimated:YES];
    //                        });
    //                    }
    //                }
    //            }];
    //        }];
    //    }
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteTweet{
    if (_sendTweet) {
        _sendTweet(_tweet, YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _UIModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIModel *uimodel = _UIModels[indexPath.row];
    if (indexPath.row == 0) {
        cell.topLineStyle = CellLineStyleFill;
    }else{
        cell.topLineStyle = CellLineStyleNone;
    }
    cell.bottomLineStyle = CellLineStyleDefault;
    if (indexPath.row == 3) {
        cell.bottomLineStyle = CellLineStyleFill;
        cell.TextField.textColor = XWColorFromHex(0xfec00c);
    }
    
    cell.image = [UIImage imageNamed:uimodel.Icon];
    cell.Title.text = uimodel.Title;
    cell.TextField.text = uimodel.TextFieldPlaceholder;
    cell.TextField.userInteractionEnabled = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ((_tweet.type == TweetTypeText) && indexPath.row == 0) {
        cell.TextField.text = @"当前时间";
        if (!_tweet.dateIndex) _tweet.dateIndex = 1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50.f);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIModel *uimodel = _UIModels[indexPath.row];
    WEAKSELF
    if (indexPath.row == 0) {
        SelectRecordingTimeViewController *selRecordingTimeVC = [[SelectRecordingTimeViewController alloc]init];
        selRecordingTimeVC.index = _tweet.dateIndex;
        selRecordingTimeVC.images = _tweet.images;
        selRecordingTimeVC.selectdeTimeBlcok = ^(NSString *TimeStr, NSInteger index) {
            weakSelf.tweet.dateIndex = index;
            if (!index) {
                uimodel.TextFieldPlaceholder = cell.TextField.text = @"拍摄时间";
                NSMutableArray *dateArray = [[NSMutableArray alloc] init];
                if (!_isVideo) { // 非视频状态排序
                    for (TweetImage *image in _tweet.images) {
                        [dateArray addObject:image.beforeModel.creationDate];
                    }
                    [dateArray sortUsingComparator:^NSComparisonResult(id dateObj1,id dateObj2) {
                        NSDate *date1=dateObj1;
                        NSDate *date2=dateObj2;
                        return [date2 compare:date1];
                    }];
                    if (dateArray.count) {
                        _newtweet.createData = [NSString stringWithFormat:@"%ld", (long)([dateArray[0] timeIntervalSince1970]*1000)];
                    } else {
                        _newtweet.createData = nil;
                    }
                    
                    return;
                } else {
                    return;
                }
            }
           cell.TextField.text = uimodel.TextFieldPlaceholder = TimeStr;
            _newtweet.dairytimetype = index + 1;
//            if (_newtweet.dairytimetype == 2) {
//                _newtweet.createData = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970]*1000];
//            } else
            if (_newtweet.dairytimetype == 3) {
//                _newtweet.createData = [NSString stringWithFormat:@"%@%@",[NSDate currentTimeString:cell.TextField.text],@"000"];
                _newtweet.diytime = [NSString stringWithFormat:@"%@%@",[NSDate currentTimeString:cell.TextField.text],@"000"];
            }
        };
        [self.navigationController pushViewController:selRecordingTimeVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        SelectFileViewController * SelectFileVC = [[SelectFileViewController alloc]init];
        SelectFileVC.files = _tweet.folders;
        SelectFileVC.house = _tweet.house;
        SelectFileVC.selectdeFoder = ^(Folder *folder) {
            uimodel.TextFieldPlaceholder = cell.TextField.text = folder.foldername;
            weakSelf.newtweet.folder = folder;
        };
        [self.navigationController pushViewController:SelectFileVC animated:YES];
    }
    if (indexPath.row == 2) {
        FriendsRangeViewController * FriendsRangeVC = [[FriendsRangeViewController alloc]init];
        FriendsRangeVC.title = @"选择可见范围";
        FriendsRangeVC.friends = _newtweet.visibleFriends;
        FriendsRangeVC.selectedFriends = _newtweet.visibleArr;
        //        FriendsRangeVC.index = _newtweet.visibleRange;
        FriendsRangeVC.house = _tweet.house;
        FriendsRangeVC.selectdeFriendsBlcok = ^(NSArray *friends, NSArray *selectedFriends, NSInteger index) {
            weakSelf.newtweet.visibleArr = [NSMutableArray arrayWithArray:selectedFriends];
            //            weakSelf.newtweet.visibleRange = index;
            weakSelf.newtweet.visibleFriends = friends;
            if (index == 0) {
                uimodel.TextFieldPlaceholder = cell.TextField.text = @"所有亲友";
                cell.TextField.textColor =kTitleAddHouseTitleCOLOR;
                [weakSelf.newtweet.visibleArr removeAllObjects];
                [weakSelf.newtweet.visibleFriends enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.selected = NO;
                }];
                _newtweet.visibleRange = 3;
                return;
            }
            if (index == 1) {
                uimodel.TextFieldPlaceholder = cell.TextField.text = @"仅自己";
                cell.TextField.textColor =kTitleAddHouseTitleCOLOR;
                [weakSelf.newtweet.visibleArr removeAllObjects];
                [weakSelf.newtweet.visibleFriends enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.selected = NO;
                }];
                _newtweet.visibleRange = 1;
                return;
            }
            if (selectedFriends.count == 1) {
                User *user = [Login curLoginUser];
                User *obj = selectedFriends.firstObject;
                if (user.uid == obj.uidconcert) {
                    uimodel.TextFieldPlaceholder = cell.TextField.text = @"仅自己";
                    cell.TextField.textColor =kTitleAddHouseTitleCOLOR;
                    _newtweet.visibleRange = 1;
                    return;
                }
            }
            //            __block NSString *remind;
            //            [selectedFriends enumerateObjectsUsingBlock:^(User *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                if (remind.length == 0) {
            //                    remind = obj.username;
            //                }else{
            //                    remind = [NSString stringWithFormat:@"%@,%@",remind,obj.username];
            //                }
            //            }];
            NSString *remind = [NSString stringWithFormat:@"%ld位亲友", selectedFriends.count];
            _newtweet.visibleRange = 2;
            uimodel.TextFieldPlaceholder = cell.TextField.text = remind;
            cell.TextField.textColor = XWColorFromHex(0xfec00c);
        };
        
        [self.navigationController pushViewController:FriendsRangeVC animated:YES];
    }
    if (indexPath.row == 3) {
        if (self.friends.count == 1) {
            [NSObject showHudTipStr:@"您还没有亲友"];
            return;
        }
        SelectFriendsViewController * FriendsRangeVC = [[SelectFriendsViewController alloc]init];
        FriendsRangeVC.friends = [NSMutableArray arrayWithArray:_tweet.remindFriends];
        FriendsRangeVC.selectedFriends = _newtweet.remindArr;
        FriendsRangeVC.house = _tweet.house;
        FriendsRangeVC.selectdeFriendsBlcok = ^(NSArray *friends, NSArray *selectedFriends) {
            weakSelf.newtweet.remindArr = [NSMutableArray arrayWithArray:selectedFriends];
            weakSelf.tweet.remindFriends = friends;
            __block NSString *remind;
            [selectedFriends enumerateObjectsUsingBlock:^(User *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (remind.length == 0) {
                    remind = obj.username;
                }else{
                    remind = [NSString stringWithFormat:@"%@,%@",remind,obj.username];
                }
            }];
            uimodel.TextFieldPlaceholder = cell.TextField.text = remind;
            cell.TextField.textColor = XWColorFromHex(0xfec00c);
        };
        [self.navigationController pushViewController:FriendsRangeVC animated:YES];
    }
    
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;//section头部高度
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
    return 30.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - private methods 私有方法
//获取好友
-(void)getFriends{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_FindersWithHouse:_tweet.house Block:^(id data, NSError *error) {
        NSArray *arr = [NSArray new];
        arr = [User mj_objectArrayWithKeyValuesArray:data];
        weakSelf.tweet.visibleFriends = [[NSArray alloc]initWithArray:arr copyItems:YES];
        weakSelf.tweet.remindFriends = [[NSArray alloc]initWithArray:arr copyItems:YES];
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
        _tableView.estimatedRowHeight = 50;
        _tableView.tableHeaderView = self.tableViewHeaderView;
        if (_isEdit) {
            _tableView.tableFooterView = self.deleteBtn;
        }
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _tableView;
}

-(HouseChangeHeaderView *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[HouseChangeHeaderView alloc]initWihtManager:self.manager];
        _tableViewHeaderView.controller = self;
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        _tableViewHeaderView.frame = CGRectMake(0, 0, kScreen_Width, (_tweet.images.count+1)/4*(kRKBHEIGHT(90) + kRKBHEIGHT(10)) + ((_tweet.images.count+1)%4?kRKBHEIGHT(90) : 0) + 135);
        _tableViewHeaderView.content = _tweet.dairydesc.length ? _tweet.dairydesc :_tableViewHeaderView.TextView.text;
        _tableViewHeaderView.tweet = _tweet;
        WEAKSELF
        _tableViewHeaderView.UPHeaderViewHeight = ^(CGFloat height) {
            weakSelf.tableViewHeaderView.height = height+10 > (20/4*kRKBHEIGHT(100) + (20%4 ? kRKBHEIGHT(90) : 0) + 95) ? (20/4*kRKBHEIGHT(100) + (20%4 ? kRKBHEIGHT(90) : 0) + 95) : height+10;
            [weakSelf.tableView reloadData];
        };
        _tableViewHeaderView.SelectedImages = ^(NSMutableArray *arr) {
            weakSelf.newtweet.images = arr;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            AddHouseTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (_tweet.type == TweetTypeText) {
                if (arr.count != 0) {
                    cell.TextField.text =[self maxTimestamp:_tweet.images];
                    _tweet.dateIndex = 0;
                }
            }
        };
        _tableViewHeaderView.TextViewEditing = ^(NSString *content) {
            weakSelf.newtweet.dairydesc = content;
        };
        [_tableViewHeaderView setVideoClick:^{
            VideoTtimmerViewController *vc = [VideoTtimmerViewController sharedInstance];
            vc.againEdit = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _tableViewHeaderView;
}

-(UIButton *)deleteBtn{
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, _tableView.width, 50);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteTweet) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _deleteBtn.width, 0.5)];
        topLine.height = 0.5f;
        [topLine setBackgroundColor:kLineColer];
        [topLine setAlpha:1];
        [_deleteBtn addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _deleteBtn.height -0.5, _deleteBtn.width, 0.5)];
        bottomLine.height = 0.5f;
        [bottomLine setBackgroundColor:kLineColer];
        [bottomLine setAlpha:1];
        [_deleteBtn addSubview:bottomLine];
    }
    return _deleteBtn;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSString *)maxTimestamp:(NSArray *)array {
    if (array.count == 0) return @"";
    __block NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
    [array enumerateObjectsUsingBlock:^(TweetImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lastDate = [lastDate laterDate:obj.creationDate];
    }];
    return [lastDate ymdFormat] ;
}


@end
