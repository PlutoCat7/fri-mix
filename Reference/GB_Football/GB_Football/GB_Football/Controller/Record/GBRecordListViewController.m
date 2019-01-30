//
//  GBRecordListViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordListViewController.h"
#import "GameRecordTableViewCell.h"
#import "GBMenuViewController.h"
#import "GBRecordDetailViewController.h"
#import "MJRefresh.h"
#import "GBBaseViewController+Empty.h"
#import "SINavigationMenuView.h"

#import "LanguageManager.h"
#import "RecordListViewModel.h"

@interface GBRecordListViewController () <
SINavigationMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recordTable;
@property (nonatomic,strong) SINavigationMenuView           *navBarMenu;
@property (nonatomic, strong) RecordListViewModel *viewModel;

@end

@implementation GBRecordListViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[RecordListViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            self.isShowEmptyView = self.viewModel.cellModels.count == 0;
            [self.recordTable reloadData];
        }];
        
        [self.yah_KVOController observe:_viewModel keyPath:@"errorMsg" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self showToastWithText:self.viewModel.errorMsg];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.recordTable.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchCompleteNotification) name:Notification_Match_Handle_Complete object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Record;
}

#pragma mark - Notification

- (void)matchCompleteNotification {
    
    [self.viewModel getFirstPageMatchList:nil];
}

#pragma mark - Delegate

#pragma mark SINavigationMenuDelegate

- (void)didSelectItemAtIndex:(NSUInteger)index {
    
    if (index == RecordGameType_All) {
        [UMShareManager event:Analy_Click_Record_All];
        
    } else if (index == RecordGameType_Standard) {
        [UMShareManager event:Analy_Click_Record_Standard];
        
    } else if (index == RecordGameType_Define) {
        [UMShareManager event:Analy_Click_Record_Quarter];
        
    } else if (index == RecordGameType_ATeam) {
        [UMShareManager event:Analy_Click_Record_Team];
    }
    
    if (index != self.viewModel.gameType) {
        self.viewModel.gameType = index;
        [self.recordTable.mj_header beginRefreshing];
    }
}

#pragma mark TableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cellModels.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameRecordTableViewCell"];
    cell.bgView.backgroundColor = (indexPath.row%2 == 0)?[UIColor colorWithHex:0x2c2f34]:[UIColor colorWithHex:0x41444d];
    RecordListCellModel *model = self.viewModel.cellModels[indexPath.row];
    [cell refreshWithModel:model];
    
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (NSInteger)(95.f*kAppScale);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MatchInfo *matchInfo = [self.viewModel matchInfoWithIndexPath:indexPath];
    if (matchInfo.status == 0) {
        return;
    }
    
    [UMShareManager event:Analy_Click_Record_Detail];
    
    GBRecordDetailViewController *vc = [[GBRecordDetailViewController alloc] initWithMatchId:matchInfo.matchId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.viewModel.cellModels.count-1 == indexPath.row) {
        [self.viewModel getNextPageMatchList:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {

        @strongify(self)
        [self.viewModel deleteMatchWithIndexPath:indexPath];
    };
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LS(@"common.btn.delete") handler:rowActionHandler];
        return @[action];
}


#pragma mark - Action

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"record.nav.tile");
    [self setupBackButtonWithBlock:nil];
    [self setupNavBar];
    
    [self.recordTable registerNib:[UINib nibWithNibName:@"GBRecordListCell" bundle:nil] forCellReuseIdentifier:@"GBRecordListCell"];
    [self.recordTable registerNib:[UINib nibWithNibName:@"GameRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameRecordTableViewCell"];
    self.recordTable.backgroundColor = [UIColor clearColor];
    self.recordTable.separatorColor = [UIColor blackColor];
    self.emptyScrollView = self.recordTable;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getFirstPageMatchList:^(NSError *error) {
            [self.recordTable.mj_header endRefreshing];
        }];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.recordTable.mj_header = mj_header;
}

-(void)setupNavBar
{
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.navBarMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:LS(@"personal.region.all")];
        self.navBarMenu.items = @[LS(@"personal.region.all"),
                                  LS(@"multi-section.standard.mode"),
                                  LS(@"multi-section.multi-section.mode"),
                                  LS(@"team.match.section.mode")];
        self.navBarMenu.delegate = self;
        self.navigationItem.titleView = self.navBarMenu;
        [self.navBarMenu displayMenuInView:self.navigationController.view];
    }
    @weakify(self)
    [self setupBackButtonWithBlock:^{
        
        @strongify(self)
        [self.navBarMenu remove];
    }];
}

@end
