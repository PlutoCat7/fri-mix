//
//  HouseChangeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseMoveTweetViewController.h"
#import "HouseMoreTweetTableViewCell.h"
#import "HouseChangeViewController.h"
#import "HXPhotoManager.h"
#import "Folder.h"

@interface HouseMoveTweetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HouseMoveTweetViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tweets enumerateObjectsUsingBlock:^(HouseTweet *tweet, NSUInteger idx, BOOL * _Nonnull stop) {
        if (tweet.images.count == 0) {
            [_tweets removeObject:tweet];
        }
    }];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"房屋新变化";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] animated:YES];
    [self tableView];
    
    HouseTweet *tweet = _tweets[0];
    
    [[TiHouse_NetAPIManager sharedManager] request_FilesBlockWith:tweet.house Block:^(id data, NSError *error) {
        [self.view endLoading];
        if (data) {
            NSArray *dataArray = (NSArray *)data;
            for (Folder *folder in dataArray) {
                if (folder.foldertype == 1) {
                    for (HouseTweet *tweet in _tweets) {
                        tweet.folder = folder;
                    }
                    return;
                }
            }
        }
    }];

    for (HouseTweet *tweet in _tweets) {
        tweet.visibleRange = 3;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
-(void)finish{
    
    if (_sendTweet) {
        _sendTweet(_tweets);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
    if (_tweets.count) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"有数啦新动态还未发送，是否需要放弃？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancen = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *finish = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertVC addAction:cancen];
        [alertVC addAction:finish];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tweets.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseMoreTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    HouseTweet *tweet = _tweets[indexPath.section];
    cell.controller = self;
    cell.indexPath = indexPath;
    cell.tweet = tweet;
    [cell setDeletePhotoCallback:^{
        [_tweets enumerateObjectsUsingBlock:^(HouseTweet *tweet, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tweet.images.count == 0) {
                [_tweets removeObject:tweet];
            }
        }];
        [_tableView reloadData];

    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HouseMoreTweetTableViewCell cellHeightWithObj:_tweets[indexPath.section] needTopView:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self aa:_tweets[indexPath.section]];
    HouseChangeViewController *houseChange = [[HouseChangeViewController alloc]init];
    houseChange.tweet = _tweets[indexPath.section];
    houseChange.manager = _manager;
    houseChange.title = @"编辑";
    houseChange.isEdit = YES;
    WEAKSELF
    houseChange.sendTweet = ^(HouseTweet *tweet, BOOL isDelete) {
        if (isDelete) {
            [weakSelf.tweets removeObject:tweet];
            [weakSelf.tableView reloadData];
            return;
        }
//        [weakSelf.tweets replaceObjectAtIndex:indexPath.section withObject:tweet];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:houseChange animated:YES];

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
    return 15.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - private methods 私有方法

-(void)aa:(HouseTweet *)tweet{
    
    for (TweetImage *image in tweet.images) {
        HXPhotoModel *model = [HXPhotoModel photoModelWithImage:image.image];
        [_manager beforeSelectedListAddPhotoModel:image.beforeModel];
        [self.manager afterSelectedArrayReplaceModelAtModel:image.beforeModel withModel:model];
        [_manager afterSelectedListAddEditPhotoModel:model];
    }
    
}

#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[HouseMoreTweetTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
