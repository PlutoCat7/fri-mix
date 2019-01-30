//
//  AssemDetailContainerViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemDetailContainerViewController.h"
#import "AssemDetailViewController.h"
#import "FindPhotoDetailViewController.h"
#import "UIViewController+YHToast.h"
#import "FindPhotoPostViewController.h"

#import "OJLWaterLayout.h"
#import "FindWaterfallCollectionViewCell.h"
#import "AssemSegmentView.h"

#import "AssemDetailStore.h"
#import "YAHKVOController.h"
#import "FindPostTool.h"
#import "FindAddPhotoPresentTool.h"
#import "NotificationConstants.h"
#import "GBSharePan.h"
#import "AssemarcRequest.h"
#import "FindAssemarcInfo.h"

@interface AssemDetailContainerViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
OJLWaterLayoutDelegate,
GBSharePanDelegate,
AssemSegmentViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (nonatomic, strong) OJLWaterLayout* layout;
@property (nonatomic, strong) AssemDetailViewController *headerVC;
@property (nonatomic, strong) FindAssemActivityInfo *assemInfo;
@property (nonatomic, strong) AssemDetailStore *store;
@property (nonatomic, strong) FindAddPhotoPresentTool *addPhotoPresentTool;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation AssemDetailContainerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithAssemInfo:(FindAssemActivityInfo *)info {
    
    self = [super init];
    if (self) {
        _assemInfo = info;
        _store = [[AssemDetailStore alloc] initWithAssemId:info.assemid];
        _store.type = 2;//最新2
        WEAKSELF
        [self.yah_KVOController observe:self.store keyPaths:@[@"cellModels"] block:^(id observer, id object, NSDictionary *change) {
            
            [weakSelf.collectionView reloadData];
        }];
    }
    return self;
}

- (instancetype)initWithAssemId:(long)assemId {
    
    self = [super init];
    if (self) {
        _store = [[AssemDetailStore alloc] initWithAssemId:assemId];
        _store.type = 2;//最新2
        WEAKSELF
        [self.yah_KVOController observe:self.store keyPaths:@[@"cellModels"] block:^(id observer, id object, NSDictionary *change) {
            
            [weakSelf.collectionView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasPostPhoto) name:Notification_Posted_Photo object:nil];
    @weakify(self)
    [self.yah_KVOController observe:self.headerVC keyPath:@"viewHeight" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        OJLWaterLayout *layout = (OJLWaterLayout *)self.collectionView.collectionViewLayout;
        layout.headerViewHeight = self.headerVC.viewHeight + kRKBWIDTH(45);
        [self.collectionView reloadData];
    }];
    
    if (!self.assemInfo) {
        [self.store getAssemActivityInfoWithHandler:^(NSError *error, FindAssemActivityInfo *assemInfo) {
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                self.assemInfo = assemInfo;
                self.joinButton.enabled = (assemInfo.status==1);
                self.joinButton.backgroundColor = (assemInfo.status==1)?[UIColor colorWithRGBHex:0xFDF086]:[UIColor colorWithRGBHex:0xEAEBEC];
                [self.headerVC refreshWithAssemInfo:assemInfo];
            }
        }];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showLoadingToast];
    [self.store getFirstPageDataWithHandler:^(NSError *error) {
        [self dismissToast];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [FindPhotoPostDataManager shareInstance].currentAssemActivity = nil;
}

#pragma mark - Notification

- (void)hasPostPhoto {
    
    [self.addPhotoPresentTool dismiss];
}

#pragma mark - Action

- (IBAction)antionJoin:(id)sender {
    
    [FindPhotoPostDataManager shareInstance].currentAssemActivity = self.assemInfo;
    self.addPhotoPresentTool = [[FindAddPhotoPresentTool alloc] init];
    [self.addPhotoPresentTool presentToolWithViewController:self];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"美家征集";
    
    _headerVC = [[AssemDetailViewController alloc] initWithAssemInfo:_assemInfo];
    _headerVC.view.frame = CGRectMake(0, 0, kScreen_Width, 250);
    [self addChildViewController:_headerVC];
    self.joinButton.enabled = (_assemInfo.status==1);
    self.joinButton.backgroundColor = (_assemInfo.status==1)?[UIColor colorWithRGBHex:0xFDF086]:[UIColor colorWithRGBHex:0xEAEBEC];
    
    [self setupNavigationBarRight];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    OJLWaterLayout* layout = [[OJLWaterLayout alloc] init];
    self.layout = layout;
    layout.numberOfCol = 2;
    layout.rowPanding = 0;
    layout.colPanding = 10;
    layout.headerViewHeight = _headerVC.viewHeight + kRKBWIDTH(45);
    layout.sectionInset = UIEdgeInsetsMake(19, 10, 19 + kRKBWIDTH(50), 10);
    layout.delegate = self;
    [layout autuContentSize];
    
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindWaterfallCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FindWaterfallCollectionViewCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"AssemSegmentView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AssemSegmentView"];
}

- (void)setupNavigationBarRight {
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"find_ass_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(actionShare)] animated:YES];

}

- (void)actionShare {
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
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
    
    @weakify(self)
    NSString *weiboTitle = [NSString stringWithFormat:@"%@%@", _assemInfo.assemtitle, _assemInfo.linkshare];
    NSString *title = tag == SHARE_TYPE_WEIBO ? weiboTitle : _assemInfo.assemtitle;
    NSString *content = @"你也来晒晒吧~";
    NSString *image = _assemInfo.urlshare;
    [[[UMShareManager alloc]init] webShare:tag title:title content:content
                                       url:_assemInfo.linkshare image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(7),@"typeid":@(self.assemInfo.assemid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
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

#pragma mark - AssemSegmentViewDelegate

- (void)assemSegmentViewMenuChange:(AssemSegmentView *)view Index:(NSInteger)index {
    //最新2
    self.store.type = 2;
}

#pragma mark - OJLWaterLayoutDelegate

- (CGFloat)OJLWaterLayout:(OJLWaterLayout *)OJLWaterLayout itemHeightForIndexPath:(NSIndexPath *)indexPath {
    
    if (self.store.isEmptyData) {
        return 0.1f;
    }
    
    FindWaterfallModel * model = self.store.cellModels[indexPath.row];
    if (model.caculateHeight>0) {  //已经计算
        return model.caculateHeight;
    }
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.layout.sectionInset.left - self.layout.sectionInset.right - (self.layout.colPanding * (self.layout.numberOfCol - 1))) / self.layout.numberOfCol;
    
    CGFloat scale = model.imageWidth / width;
    CGFloat imageHeight =  model.imageHeight / scale;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.font = [UIFont systemFontOfSize:kRKBWIDTH(13)];
    label.numberOfLines = 0;
    label.text = model.title;
    [label sizeToFit];
    CGFloat textHeight = label.height + kFindWaterfallCollectionViewCellTextHeight;
    
    model.caculateHeight = imageHeight + textHeight;;
    
    return model.caculateHeight;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.store.isEmptyData) {
        return 1; //占位符， 否则header无法滑动
    }
    return self.store.cellModels.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindWaterfallCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindWaterfallCollectionViewCell class]) forIndexPath:indexPath];
    if (!self.store.isEmptyData) {
        [cell refreshWithModel:_store.cellModels[indexPath.row]];
    }
    @weakify(self)
    cell.clickZanBlock = ^(FindWaterfallModel *model) {
        @strongify(self)
        FindAssemarcInfo *info = [self.store assemarcInfoWithIndexPath:indexPath];
        [self clickZan:info model:model indexPath:indexPath];
    };
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        AssemSegmentView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AssemSegmentView" forIndexPath:indexPath];
        headerView.containerView.hidden = [self.store isEmptyData];
        headerView.delegate = self;
        _headerVC.view.height = _headerVC.viewHeight;
        [headerView addSubview:_headerVC.view];
        
        return headerView;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.store isLoadEnd] &&
        self.store.cellModels.count-1 == indexPath.row) {
        [self.store getNextPageDataWithHandler:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *arcInfo = [_store assemarcInfoWithIndexPath:indexPath];
    FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:arcInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickZan:(FindAssemarcInfo *) info model:(FindWaterfallModel *)model indexPath:(NSIndexPath *)indexPath {
    if (info.assemarciszan) {
        [AssemarcRequest removeAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = NO;
            info.assemarcnumzan -= 1;
            
            model.isMeLike = info.assemarciszan;
            model.likeCount = info.assemarcnumzan;
            
            FindWaterfallCollectionViewCell *cell = (FindWaterfallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell refreshWithLikeCount:model.likeCount isLike:model.isMeLike];
        }];
    }else {
        [AssemarcRequest addAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = YES;
            info.assemarcnumzan += 1;
            
            model.isMeLike = info.assemarciszan;
            model.likeCount = info.assemarcnumzan;
            
            FindWaterfallCollectionViewCell *cell = (FindWaterfallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell refreshWithLikeCount:model.likeCount isLike:model.isMeLike];
        }];
    }
    
}
@end
