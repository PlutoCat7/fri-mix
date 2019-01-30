//
//  PlayerDetailViewController.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PlayerDetailViewController.h"

#import "PlayerDetailTableViewHeaderView.h"
#import "PlayerDetailCommontSectionView.h"
#import "PalyerDetailCommentCell.h"
#import "PalyerDetailCommentEndCell.h"
#import "CommentInputView.h"

#import "PlayerDetailCommentCellModel.h"
#import "PlayerDetailStore.h"

@interface PlayerDetailViewController () <
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
PlayerDetailTableViewHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerContainterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) PlayerDetailTableViewHeaderView *tableHeaderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopLayoutConstraint;


@property (nonatomic, strong) PlayerDetailStore *store;

@end

@implementation PlayerDetailViewController

- (void)dealloc
{
    [[RawCacheManager sharedRawCacheManager] releasePlayerView];
    NSLog(@"dealloc PlayerDetailViewController");
}

- (instancetype)initWithVideoId:(NSInteger)videoId {
    
    return [self initWithVideoId:videoId videoInfo:nil];
}
- (instancetype)initWithVideoInfo:(VideoDetailInfo *)videoInfo {
    
    return [self initWithVideoId:0 videoInfo:videoInfo];
}

- (instancetype)initWithVideoId:(NSInteger)videoId videoInfo:(VideoDetailInfo *)videoInfo
{
    self = [super init];
    if (self) {
        _store = [[PlayerDetailStore alloc] initWithVideoId:videoId videoInfo:videoInfo];
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
    [self setupUI];
    
    @weakify(self)
    [self.store loadVideoInfoWithHandle:^(NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            CLPlayerView *playerView = [RawCacheManager sharedRawCacheManager].playerView;
            if (!playerView.videoModel) { //新的播放器
                playerView.videoModel = _store.videoModel;
            }
            [playerView playVideo];
            [self.tableHeaderView refreshWithModel:_store.headerModel];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [RawCacheManager sharedRawCacheManager].playerView.frame = self.playerContainterView.bounds;
            self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kPlayerDetailTableViewHeaderViewHeight);
            [self.tableView setTableHeaderView:self.tableHeaderView];
        });
    });
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    self.contentViewTopLayoutConstraint.constant = IS_IPHONE_X?kUIScreen_TopBarContentY:0;
}

#pragma mark - Action

- (IBAction)actionInputComment:(id)sender {
    
    [CommentInputView showWithCommentBlock:^(NSString *comment) {
        [self showLoadingToast];
        [_store commentWithContent:comment handler:^(NSError *error) {
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }
        }];
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupPlayerView];
    [self setupTableView];
    
    self.commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"写个评论和球友们聊聊天呗" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xbfc6cd]}];
}

- (void)setupPlayerView {
    
    CLPlayerView *playerView = [RawCacheManager sharedRawCacheManager].playerView;
    playerView.frame = self.playerContainterView.bounds;
    playerView.topToolBarHiddenType = TopToolBarHiddenNever;
    if (!playerView.videoModel) { //新的播放器
        playerView.videoModel = _store.videoModel;
    }
    @weakify(self)
    playerView.BackBlock = ^{
        
        @strongify(self)
        if (!self) {
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.playerContainterView addSubview:playerView];
    
    [playerView playVideo];
    
    [_store watchVideo];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PalyerDetailCommentCell" bundle:nil] forCellReuseIdentifier:@"PalyerDetailCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PalyerDetailCommentEndCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PalyerDetailCommentEndCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlayerDetailCommontSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PlayerDetailCommontSectionView"];
    self.tableView.tableHeaderView = self.tableHeaderView;

}

#pragma mark - Setter and Getter

- (PlayerDetailTableViewHeaderView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"PlayerDetailTableViewHeaderView" owner:self options:nil].firstObject;
        [_tableHeaderView refreshWithModel:_store.headerModel];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

#pragma mark - PlayerDetailTableViewHeaderViewDelegate

- (void)praiseWithPlayerDetailTableViewHeaderView:(PlayerDetailTableViewHeaderView *)headerView {
    
    [self showLoadingToast];
    [_store praiseWithHandler:^(NSError *error) {
        
        [self dismissToast];
        if (error) {
        }else {
            [self.tableHeaderView refreshWithModel:self.store.headerModel];
        }
    }];
}

- (void)collectionWithPlayerDetailTableViewHeaderView:(PlayerDetailTableViewHeaderView *)headerView {
    
    [self showLoadingToast];
    [_store collectWithHandler:^(NSError *error) {
        
        [self dismissToast];
        if (error) {
        }else {
            [self.tableHeaderView refreshWithModel:self.store.headerModel];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {//发送
        return NO;
    }
    if ([string isEqualToString:@""]) { //删除
        return YES;
    }
    if (textField.text.length >= _store.commentLength) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.store.cellModels.count>0) {
        return self.store.cellModels.count + 1;
    }else {
        return 0;
    }
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<self.store.cellModels.count) {
        return _store.cellModels[indexPath.row].cellHeight;
    }else {
        return kPalyerDetailCommentEndCellHeight;
    }
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kPlayerDetailCommontSectionViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<self.store.cellModels.count) {
    
        PalyerDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PalyerDetailCommentCell"];
        [cell refreshWithModel:_store.cellModels[indexPath.row]];
    
        return cell;
    }else {
        PalyerDetailCommentEndCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PalyerDetailCommentEndCell class])];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PlayerDetailCommontSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PlayerDetailCommontSectionView"];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView refreshWithCommentCount:_store.cellModels.count];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.store isLoadEnd] &&
        self.store.cellModels.count-1 == indexPath.row) {
        [self.store getNextPageDataWithHandler:^(NSError *error) {
            if (error) {
                [self showToastWithText:error.domain];
            }
        }];
    }
}

@end
