//
//  Find_RootViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "Find_RootViewController.h"
#import "BaseNavigationController.h"
#import "FindAddPreviewViewController.h"
#import "FindSearchResultViewController.h"
#import "HomeAssemActivityViewController.h"
#import "FindArticleDetailViewController.h"
#import "FindPhotoDetailViewController.h"
#import "FindPhotoPreviewViewController.h"
#import "FindWaterfallViewController.h"
#import "YAHKVOController.h"
#import "UIViewController+YHToast.h"

#import "FindSegmentView.h"
#import "MJRefresh.h"
#import "FindRootArticelCell.h"
#import "FindRootPhotoSingleCell.h"
#import "FindRootPhotoMutiCell.h"
#import "FindRootCellProtocol.h"
#import "GBSharePan.h"

#import "FindRootStore.h"
#import "FindAssemarcInfo.h"
#import "UnReadManager.h"

@interface Find_RootViewController () <
FindSegmentViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
GBSharePanDelegate,
FindRootCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HomeAssemActivityViewController *assemVC;

@property (nonatomic, strong) FindRootStore *store;
@property (nonatomic, strong) FindRootArticelCell *caculateHeightArticelCell;
@property (nonatomic, strong) FindRootPhotoSingleCell *caculateHeightPhotoSingleCell;
@property (nonatomic, strong) FindRootPhotoMutiCell *caculateHeightPhotoMutiCell;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation Find_RootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _store = [[FindRootStore alloc] init];
        WEAKSELF
        [self.yah_KVOController observe:self.store keyPaths:@[@"cellModels"] block:^(id observer, id object, NSDictionary *change) {
            
            [weakSelf.tableView reloadData];
            
        }];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"发现";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find_issue"] style:UIBarButtonItemStylePlain target:self action:@selector(issueAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    FindSegmentView *headerView = [[NSBundle mainBundle] loadNibNamed:@"FindSegmentView" owner:self options:nil].firstObject;
    headerView.delegate = self;
    self.navigationItem.titleView = headerView;
    
    [self setupTableView];
    
    //获取数据
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UnReadManager shareManager] updateUnRead];
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    _assemVC.view.frame = CGRectMake(0, 0, kScreen_Width, kRKBWIDTH(185));
    self.tableView.tableHeaderView = _assemVC.view;
}

#pragma mark - Action

- (void)searchAction {
    
    FindSearchResultViewController *vc = [[FindSearchResultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)issueAction {
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[FindAddPreviewViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - Private

- (void)setupTableView {
    
    _caculateHeightArticelCell = [[NSBundle mainBundle] loadNibNamed:@"FindRootArticelCell" owner:self options:nil].firstObject;
    _caculateHeightPhotoSingleCell = [[NSBundle mainBundle] loadNibNamed:@"FindRootPhotoSingleCell" owner:self options:nil].firstObject;
    _caculateHeightPhotoMutiCell = [[NSBundle mainBundle] loadNibNamed:@"FindRootPhotoMutiCell" owner:self options:nil].firstObject;
    
    _assemVC = [[HomeAssemActivityViewController alloc] init];
    _assemVC.view.frame = CGRectMake(0, 0, kScreen_Width, kRKBWIDTH(185));
    [self addChildViewController:_assemVC];
    self.tableView.tableHeaderView = _assemVC.view;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRootPhotoMutiCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindRootPhotoMutiCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRootArticelCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindRootArticelCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindRootPhotoSingleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindRootPhotoSingleCell class])];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.store getFirstPageDataWithHandler:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_header = mj_header;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTABBARH, 0);
}

#pragma mark - FindSegmentViewDelegate

- (void)findSegmentViewMenuChange:(FindSegmentView *)view Index:(NSInteger)index {
    
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    self.store.type = index;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - FindRootCellDelegate

- (void)findRootCellaAtionAttention:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    [_store attentionWithIndexPath:indexPath handler:^(BOOL isSuccess) {
        [self dismissToast];
    }];
}

- (void)findRootCellaAtionLike:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    [_store likeArticleWithIndexPath:indexPath handler:^(BOOL isSuccess) {
       
        [self dismissToast];
        if (isSuccess) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)findRootCellaAtionCollection:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    [_store favorArticleWithIndexPath:indexPath handler:^(BOOL isSuccess) {
        
        [self dismissToast];
        if (isSuccess) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)findRootCellaAtionComment:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindAssemarcInfo *info = [_store assemarcInfoWithIndexPath:indexPath];
    if (info.assemarctype==1) {
        FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (info.assemarctype==2) {
        FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)findRootCellaAtionShare:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.sharePan.tag = indexPath.row;
    
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
}

- (void)findRootCellaAtionImageClick:(UITableViewCell *)cell imageIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindAssemarcInfo *info = _store.cellModels[indexPath.row];
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:[_store photoPreviewModelsWithIndexPath:indexPath] showIndex:index arcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)findRootCellaAtionLabel:(UITableViewCell *)cell labelTitle:(NSString *)title {
    
//    FindWaterfallViewController *vc = [[FindWaterfallViewController alloc] initWithSearchName:title];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 分享功能

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}
// share delegate
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [self clickShare:tag];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    
    NSString *platform;
    switch (tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            platform = @"1";
        }
            break;
        case SHARE_TYPE_QQ:
        {
            platform = @"2";
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            platform = @"3";
        }
            break;
        default:
        {
            platform = @"4";
        }
            break;
    }
    NSInteger row = self.sharePan.tag;
    if (row >= self.store.cellModels.count) {
        return;
    }
    
    FindAssemarcInfo *info = self.store.cellModels[row];
    NSString *url = info.linkshare;
    NSString *title = info.assemarctype == 1 ? info.assemtitle : @"我在【有数啦】发布了有趣的图片，快来围观吧！";
    if (tag == SHARE_TYPE_WEIBO && info.linkshare.length > 0) {
        title = [NSString stringWithFormat:@"%@%@", title, info.linkshare];
    }
    NSString *content = info.assemarctype == 1 ? @"【有数啦】你值得拥有的家装神器！" : @"等你来哦~";
    NSString *image = info.assemarctype == 1 ? info.urlindex : nil;
    @weakify(self)
    [[[UMShareManager alloc]init] webShare:tag title:title content:content
                                       url:info.linkshare image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(8),@"typeid":@(info.assemarcid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                 }];
             }break;
                 
             case 1: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享失败"];
                 [self.sharePan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.store.cellModels.count;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = self.store.cellModels[indexPath.row];
    BOOL isMoreFourLine = NO;
    if (info.assemarctype != 1) {
        NSString *fourLineString = @"test\ntest\ntest\ntest";
        CGFloat fourHeight = [fourLineString getHeightWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
        NSString *content = @"";
        if (!info.assemtitle ||
            [info.assemtitle isEmpty]) {
            content = info.assemarctitle;
        }else {
            NSString *assemTitle = [NSString stringWithFormat:@"#%@#", info.assemtitle];
            content = [NSString stringWithFormat:@"%@%@", assemTitle, content];
        }
        CGFloat contentHeight = [content getHeightWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kRKBWIDTH(351), MAXFLOAT)];
        isMoreFourLine = contentHeight>fourHeight;
    }
    NSNumber *heightNumber = [_store.cacheCellHeightDictionary objectForKey:@(info.assemarcid)];
    if (heightNumber && !isMoreFourLine) {
        return [heightNumber floatValue];
    }else {
        CGFloat height = 0;
        if (info.assemarctype == 1) { //文章
            height = [self.caculateHeightArticelCell getHeightWithSubTitle:info.assemarctitlesub];
            
        }else {  //图片
            if (info.assemarcfileJA.count<=1) {
                height = [self.caculateHeightPhotoSingleCell getHeightWithArcInfo:info];
            }else {
                height = [self.caculateHeightPhotoMutiCell getHeightWithArcInfo:info];
            }
        }
        [_store.cacheCellHeightDictionary setObject:@(height) forKey:@(info.assemarcid)];
        return height;
    }
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindAssemarcInfo *info = [_store assemarcInfoWithIndexPath:indexPath];
    if (info.assemarctype == 1) {
        FindRootArticelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindRootArticelCell class])];
        cell.delegate = self;
        [cell refreshWithInfo:info];
        return cell;
    }else {
        if (info.assemarcfileJA.count<=1) {
            FindRootPhotoSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindRootPhotoSingleCell class])];
            cell.delegate = self;
            @weakify(self)
            cell.needRefreshView = ^{
                @strongify(self)
                [self.tableView reloadData];
            };
            [cell refreshWithInfo:info];
            return cell;
        }else {
            FindRootPhotoMutiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindRootPhotoMutiCell class])];
            cell.delegate = self;
            @weakify(self)
            cell.needRefreshView = ^{
                @strongify(self)
                [self.tableView reloadData];
            };
            [cell refreshWithInfo:info];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.store isLoadEnd] &&
        self.store.cellModels.count-1 == indexPath.row) {
        [self.store getNextPageDataWithHandler:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = [_store assemarcInfoWithIndexPath:indexPath];
    if (info.assemarctype==1) {
        FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (info.assemarctype==2) {
        FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
