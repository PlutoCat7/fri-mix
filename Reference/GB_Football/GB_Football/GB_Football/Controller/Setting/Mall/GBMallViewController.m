//
//  GBMallViewController.m
//  GB_Football
//
//  Created by Pizza on 2016/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMallViewController.h"
#import "GBMenuViewController.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "ShopRequest.h"
#import "APNSManager.h"
#import "GBMallCell.h"
#import "MJRefresh.h"

@interface GBMallViewController ()<SDCycleScrollViewDelegate,GBMallCellDelegate>

@property (nonatomic, strong) ShopInfo *shopInfo;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIView             *headerView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView  *bannerView;

@end

@implementation GBMallViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"mall.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    
    //加载缓存
    ShopResponseInfo * info = [ShopResponseInfo loadCache];
    if (info) {
        self.shopInfo = info.data;
        [self refreshUI];
    }
}

- (void)setupTableView
{
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBMallCell" bundle:nil] forCellReuseIdentifier:@"GBMallCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.headerView.bounds = CGRectMake(0, 0,
                                        [UIScreen mainScreen].bounds.size.width,
                                        ([UIScreen mainScreen].bounds.size.width/375.f)*175.f + 12.f);
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getShopInfo];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)bannerUIRefresh
{
    NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:self.shopInfo.banner.count];
    for (ShopItemInfo *itemInfo in self.shopInfo.banner) {
        [imageList addObject:itemInfo.image_url];
    }
    self.bannerView.imageURLStringsGroup = [imageList copy];
    self.bannerView.delegate = self;
    self.bannerView.pageControlAliment  = SDCycleScrollViewPageContolAlimentLeft;
    self.bannerView.currentPageDotImage = [UIImage imageNamed:@"rolling_s"];
    self.bannerView.pageDotImage        = [UIImage imageNamed:@"rolling_n"];
    self.bannerView.autoScrollTimeInterval = 6 > 1 ? 3.f : MAXFLOAT;
}

- (void)refreshUI
{
    [self bannerUIRefresh];
    [self.tableView reloadData];
}

- (void)getShopInfo
{
    @weakify(self)
    [ShopRequest getShopInfoWithHandler:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.shopInfo = result;
            [self refreshUI];
        }
    }];
}

#pragma mark - Delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (index>self.shopInfo.banner.count - 1) {
        return;
    }
    ShopItemInfo *itemInfo = self.shopInfo.banner[index];
    [[APNSManager shareInstance] pushShopItem:itemInfo];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopInfo.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBMallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBMallCell"];
    
    ShopItemInfo *itemInfo = self.shopInfo.list[indexPath.row];
    [cell refreshWithImageUrl:itemInfo.image_url];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width * (350.f/750.f) + 12.f;
}

- (void)GBMallCellDidSelect:(GBMallCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShopItemInfo *itemInfo = self.shopInfo.list[indexPath.row];
    [[APNSManager shareInstance] pushShopItem:itemInfo];
    
    if (![NSString stringIsNullOrEmpty:itemInfo.param_url] && [itemInfo.param_url containsString:@"jd"]) {
        [UMShareManager event:Analy_Click_Jingdong];
        
    } else if (![NSString stringIsNullOrEmpty:itemInfo.param_url] && [itemInfo.param_url containsString:@"taobao"]) {
        [UMShareManager event:Analy_Click_Taobao];
    }
    
}

@end
