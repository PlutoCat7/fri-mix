//
//  VideoListViewController.m
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoListViewController.h"
#import "GBHomeViewController.h"
#import "PlayerDetailViewController.h"

#import "VideoListCell.h"
#import "CLPlayerView.h"
#import "MJRefresh.h"

#import "VideoListStore.h"
#import "VideoRequest.h"

@interface VideoListViewController ()<
UITableViewDelegate,
UITableViewDataSource,
VideoListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**记录Cell*/
@property (nonatomic, assign) VideoListCell *playerCell;

@property (nonatomic, strong) VideoListStore *store;
@property (nonatomic, strong) NSString *titleString;

@end

@implementation VideoListViewController

- (void)dealloc
{
    if (_playerCell) {
        [[RawCacheManager sharedRawCacheManager] releasePlayerView];
    }
}

- (instancetype)initWithTopicId:(NSInteger)topicId;
{
    self = [super init];
    if (self) {
        _store = [[VideoListStore alloc] initWithTopicId:topicId];
        @weakify(self)
        [self.yah_KVOController observe:_store keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self.tableView reloadData];
        }];
    }
    return self;
}

- (instancetype)initWithTopicId:(NSInteger)topicId title:(NSString *)title {
    self = [super init];
    if (self) {
        _store = [[VideoListStore alloc] initWithTopicId:topicId];
        _titleString = title;
        
        @weakify(self)
        [self.yah_KVOController observe:_store keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self.tableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomeViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self resetPalyerView];
}

#pragma mark - Private

- (void)setupUI {
 
    self.title = [NSString stringIsNullOrEmpty:_titleString] ? @"" : _titleString;
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoListCell class])];
    self.tableView.rowHeight = kVideoListCellHeight;

    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.store getFirstPageDataWithHandler:^(NSError *error) {
            [self handlerRequestWithError:error];
        }];
    }];
    self.tableView.mj_header = mj_header;
}

- (void)handlerRequestWithError:(NSError *)error {
    
    [self.tableView.mj_header endRefreshing];
    if (error) {
        [self showToastWithText:error.domain];
    }
}

- (void)resetPalyerView {
    
    if (!_playerCell) {
        return;
    }
    
    CLPlayerView *playerView = [RawCacheManager sharedRawCacheManager].playerView;
    [playerView removeFromSuperview];
    playerView.frame = _playerCell.playerContinerView.bounds;
    [_playerCell.playerContinerView insertSubview:playerView aboveSubview:_playerCell.playButton];
    playerView.topToolBarHiddenType = TopToolBarHiddenSmall;
}

- (void)pushVideoDetailWithCell:(VideoListCell *)cell {
    
    if (_playerCell && _playerCell != cell) {
        [[RawCacheManager sharedRawCacheManager] releasePlayerView];
    }
    _playerCell = cell;
    [[RawCacheManager sharedRawCacheManager] retainPlayerView];
    
    PlayerDetailViewController *vc = [[PlayerDetailViewController alloc] initWithVideoInfo:[_store videoInfoWithIndexPath:[_tableView indexPathForCell:cell]]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - VideoListCellDelegate

- (void)playVideoWithCell:(VideoListCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    //记录被点击的Cell
    _playerCell = cell;
    //销毁播放器
    [self resetPalyerView];
    CLPlayerView *playerView = [RawCacheManager sharedRawCacheManager].playerView;
    playerView.videoModel = (CLVideoModel *)_store.cellModels[indexPath.row];
    [playerView playVideo];
    [_store watchWithIndexPath:indexPath];
}

- (void)praiseVideoWithCell:(VideoListCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    [_store praiseWithIndexPath:indexPath handler:^(NSError *error) {
        
        [self dismissToast];
        if (!error) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)collectVideoWithCell:(VideoListCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    [_store collectWithIndexPath:indexPath handler:^(NSError *error) {
        
        [self dismissToast];
        if (error) {
            
        }else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)commentVideoWithCell:(VideoListCell *)cell {
    
    [self pushVideoDetailWithCell:cell];
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _store.cellModels.count;
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

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoListCell class])];
    cell.delegate = self;
    [cell refreshWithModel:_store.cellModels[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.store isLoadEnd] &&
        self.store.cellModels.count-1 == indexPath.row) {
        [self.store getNextPageDataWithHandler:^(NSError *error) {
            
            [self handlerRequestWithError:error];
        }];
    }
}

//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_playerCell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [[RawCacheManager sharedRawCacheManager] releasePlayerView];
        _playerCell = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoListCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    [self pushVideoDetailWithCell:selectCell];
}

@end
