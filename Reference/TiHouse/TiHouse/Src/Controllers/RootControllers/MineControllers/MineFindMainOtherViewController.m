//
//  MineFindMainOtherViewController.m
//  TiHouse
//
//  Created by admin on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainOtherViewController.h"
#import "MineFindMainOtherHeader.h"
#import "MineFindMainActionCell.h"
#import "MineFindMainContentCell.h"
#import "User.h"
#import "NSDate+Extend.h"
#import "AssemarcModel.h"
#import "Paginator.h"
#import "Login.h"
#import "BaseNavigationController.h"
#import "GBSharePan.h"
#import "FindPhotoPreviewViewController.h"
#import "FindArticleDetailViewController.h"
#import "FindPhotoDetailViewController.h"
#import "FindAssemarcInfo.h"
#import "UIViewController+YHToast.h"
#import "AssemarcRequest.h"

static NSString *const articleCellId = @"articleCellId";
static NSString *const singlePictureCellId = @"singlePictureCellId";
static NSString *const multiPictureCellId = @"multiPictureCellId";


@interface MineFindMainOtherViewController () <UITableViewDelegate, UITableViewDataSource, MineFindMainContentCellDelegate, GBSharePanDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineFindMainOtherHeader *tableHeader;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) Paginator *pager;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) GBSharePan *sharePan;
@end

@implementation MineFindMainOtherViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [(BaseNavigationController *)self.navigationController showNavBottomLine];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        NSLog(@"返回喵友");
        if (_reloadBlock)
        {
            _reloadBlock();
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController hideNavBottomLine];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self wr_setNavBarBackgroundAlpha:0];
//    [self wr_setNavBarShadowImageHidden:YES];

    
    _user = [Login curLoginUser];
    
    [self tableView];
    
    _dataArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(findSetting)];
    
    if (_user.uid != _uid) {
        [self getOther];
        _tableHeader.user = _user;
    }
    
    _pager = [Paginator new];
    _pager.page = 1;
    _pager.perPage = 10;
    _pager.willLoadMore = YES;
    _pager.canLoadMore = YES;
    
    [self getFindData];
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHeader;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = YES;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        WEAKSELF
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        _tableView.estimatedRowHeight = kRKBHEIGHT(70);
    }
    return _tableView;
}

-(MineFindMainOtherHeader *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[MineFindMainOtherHeader alloc]init];
        _tableHeader.frame = CGRectMake(0, 0, _tableHeader.width, IphoneX ? 265 : 240);
        _tableHeader.layer.masksToBounds = YES;
        _tableHeader.user = _user;
    }
    return _tableHeader;
}

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kRKBHEIGHT(70);
    } else {
        return [_heightArray[indexPath.section - 1] floatValue];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _dataArray.count) {
        return 0.1f;
    }
    CGFloat paddingViewHeight = kRKBWIDTH(15);
    return paddingViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _dataArray.count) {
        return nil;
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kRKBWIDTH(15))];
    return  paddingView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"actionCell";
        MineFindMainActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MineFindMainActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.user = _other;
        
        return cell;
    } else {
        if ((int)[_dataArray[indexPath.section - 1] assemarctype] == 2) {
            if ([[[_dataArray[indexPath.section - 1] urlsoulfilearr] componentsSeparatedByString:@","] count] > 1) {
                MineFindMainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCellId];
                if (!cell) {
                    cell = [[MineFindMainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multiPictureCellId];
                }
                cell.model = _dataArray[indexPath.section - 1];
                cell.delegate = self;
                return cell;
                
            } else {
                
                MineFindMainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCellId];
                if (!cell) {
                    cell = [[MineFindMainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singlePictureCellId];
                }
                cell.model = _dataArray[indexPath.section - 1];
                cell.delegate = self;
                return cell;
            }
        } else {
            
            MineFindMainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellId];
            if (!cell) {
                cell = [[MineFindMainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articleCellId];
            }
            cell.model = _dataArray[indexPath.section - 1];
            cell.delegate = self;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindAssemarcInfo *model = _dataArray[indexPath.section - 1];
    if (model.assemarctype == 1) {
        
        FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - target action
- (void)findSetting {
    
}

#pragma mark - private method

- (void)getFindData {
    
    if (!_pager.canLoadMore) {
        return;
    }
    
    
    
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarc/pageByUidother" withParams:@{@"uid": @(_user.uid),@"uidother": @(_uid), @"start": @((_pager.page - 1) * _pager.perPage), @"limit": @(_pager.perPage)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            
            if ([data[@"allCount"] intValue] > [_dataArray count] + 2) {
                _pager.canLoadMore = YES;
            } else {
                _pager.canLoadMore = NO;
            }
            
            for (NSDictionary *dic in data[@"data"]) {
                FindAssemarcInfo *model = [FindAssemarcInfo mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
                // 分别计算高度
                CGFloat height;
                if (model.assemarctype == 2) {
                    if ([[model.urlsoulfilearr componentsSeparatedByString:@","]count]>1) {
                        // 多图高度
                        CGFloat topHeight = kRKBHEIGHT(15 + 40 + 12 + 1 + 10);
                        CGFloat titleHeight = [model.assemarctitle getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                        NSArray *imagesURLArray = [model.urlsoulfilearr componentsSeparatedByString:@","];
                        NSInteger count = [imagesURLArray count];
                        CGFloat imagesHeight = kRKBHEIGHT((ceil(count / 3.0))  * 115) + 3 * (ceil(count / 3.0) - 1);
                        CGFloat bottomHeight = kRKBHEIGHT(57);
                        height = topHeight + titleHeight + imagesHeight + bottomHeight;
                    } else {
                        // 单图高度
                        CGFloat topHeight = kRKBHEIGHT(15 + 40 + 12 + 1 + 10);
                        CGFloat titleHeight = [[NSString stringWithFormat:@"%@#%@#",model.assemarctitle, model.assemtitle] getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                        CGFloat imageHeight = kRKBHEIGHT(250);
                        CGFloat bottomHeight = kRKBHEIGHT(57);
                        height = topHeight + titleHeight + imageHeight + bottomHeight;
                    }
                } else {
                    // 文章内容高度
                    CGFloat topHeight = kRKBHEIGHT(15 + 40 + 12 + 1 + 10);
                    CGFloat titleHeight = [model.assemarctitle getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                    CGFloat subTitleHeight = [model.assemarctitlesub getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                    CGFloat bottomHeight = kRKBHEIGHT(57);
                    height = topHeight + kRKBHEIGHT(175) + titleHeight + subTitleHeight + bottomHeight;
                }
                [_heightArray addObject:@(height)];
            }
            [weakSelf.tableView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)refreshMore {
    if (!_pager.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _pager.page = _pager.page + 1;
    [self getFindData];
}

- (void) getOther {
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/user/getOther" withParams:@{@"uidother": @(_uid)} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            User *tmp = [User mj_objectWithKeyValues:data[@"data"]];
            _other = tmp;
            _tableHeader.user = tmp;
            [_tableView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
    
}

#pragma mark - MineFindMainContentCellDelegate
- (void)mineFindCellDelegateShare:(MineFindMainContentCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.sharePan.tag = indexPath.section;
    
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
}

- (void)mineFineCellSingleImage:(MineFindMainContentCell *)cell imageIndex:(NSInteger)index{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindAssemarcInfo *info = self.dataArray[indexPath.section - 1];
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:[self photoPreviewModelsWithIndexPath:indexPath] showIndex:index arcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineFindCellComment:(MineFindMainContentCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindAssemarcInfo *info = _dataArray[indexPath.section - 1];
    if (info.assemarctype==1) {
        FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (info.assemarctype==2) {
        FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)mineFindCellStar:(MineFindMainContentCell *)cell {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [self showLoadingToast];
//    [self likeArticleWithIndexPath:indexPath handler:^(BOOL isSuccess) {
//
//        [self dismissToast];
//        if (isSuccess) {
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    }];
//}

// share delegate
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [self clickShare:tag];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    @weakify(self)
    [[[UMShareManager alloc]init] screenShare:tag image:nil complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
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

#pragma mark - 图片处理方法
- (NSArray<FindPhotoPreviewModel *> *)photoPreviewModelsWithIndexPath:(NSIndexPath *)indexPath {
    FindAssemarcInfo *info = self.dataArray[indexPath.section - 1];
    NSArray *photoUrlList = [info.urlsoulfilearr componentsSeparatedByString:@","];
    NSDictionary *labelDic = [info getLabelsDictionary];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (NSString *imageUrl in photoUrlList) {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageUrl = imageUrl;
        model.labelModelList = [labelDic objectForKey:imageUrl];
        [result addObject:model];
    }
    return [result copy];
    
}

- (void)likeArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = _dataArray[indexPath.section - 1];
    if (!info) {
        BLOCK_EXEC(handler, NO);
    }
    if (info.assemarciszan) {
        [AssemarcRequest removeAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = NO;
            info.assemarcnumzan -= 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {

            info.assemarciszan = YES;
            info.assemarcnumzan += 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}


@end
