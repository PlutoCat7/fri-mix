//
//  FindPhotoDetailViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoDetailViewController.h"
#import "FindPhotoDetailHeaderViewController.h"
#import "YAHKVOController.h"
#import "CommentViewController.h"
#import "CommentListViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+YHToast.h"

#import "OJLWaterLayout.h"
#import "FindWaterfallCollectionViewCell.h"
#import "PhotoDetailSectionHeaderView.h"

#import "FindPhotoDetailStore.h"
#import "FindCommentPageRequest.h"
#import "CommentPageRequest.h"
#import "NotificationConstants.h"
#import "AssemarcRequest.h"
#import "GBSharePan.h"

#import "FindPhotoPreviewViewController.h"

@interface FindPhotoDetailViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
OJLWaterLayoutDelegate,
GBSharePanDelegate,
FindPhotoDetailHeaderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;

@property (nonatomic, strong) OJLWaterLayout* layout;
@property (nonatomic, strong) FindPhotoDetailHeaderViewController *headerVC;
@property (nonatomic, strong) FindPhotoDetailStore *store;

@property (nonatomic, strong) FindCommentPageRequest *recordPageRequest;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation FindPhotoDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo {
    
    self = [super init];
    if (self) {
        _store = [[FindPhotoDetailStore alloc] initWithAssemarcInfo:arcInfo];
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
                                             selector:@selector(commentSuccess) name:Notification_Comment_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentSuccess) name:Notification_Comment_Zan object:nil];
    
    [self.store getFirstPageDataWithHandler:nil];
}

#pragma mark - Notification

- (void)commentSuccess {
    
    [self loadNetworkData];
    
    _store.arcInfo.assemarcnumcoll += 1;
    [self refreshBottomViewUI];
}

#pragma mark - Action

- (IBAction)actionComment:(id)sender {
    CommentViewController *vc = [[CommentViewController alloc] initWithCommentId:_store.arcInfo.assemarcid commId:0 commuid:0 comuname:nil type:CommentType_Asse];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionCommentList:(id)sender {
    CommentListViewController *viewController = [[CommentListViewController alloc] initWithAssenarcId:_store.arcInfo.assemarcid];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionZan:(id)sender {
    [_store zanArticleWithHandler:^(BOOL isSuccess) {
        //[self dismissToast];
        if (isSuccess) {
            [self refreshBottomViewUI];
        }
    }];
}


- (IBAction)actionShare:(id)sender {
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
}

#pragma mark - Private


- (void)setupUI {
    
    self.title = @"图文详情";
    
    [self.commentBgView.layer setMasksToBounds:YES];
    [self.commentBgView.layer setCornerRadius:3.f];
    
    [self.commentCountLabel.layer setMasksToBounds:YES];
    [self.commentCountLabel.layer setCornerRadius:6.f];
    
    _headerVC = [[FindPhotoDetailHeaderViewController alloc] init];
    _headerVC.delegate = self;
    _headerVC.view.frame = CGRectMake(0, 0, kScreen_Width, 250);
    [self addChildViewController:_headerVC];
    [_headerVC refreshWithInfo:_store.arcInfo];
    
    [self setupCollectionView];
    [self refreshBottomViewUI];
}

- (void)setupCollectionView {
    
    OJLWaterLayout* layout = [[OJLWaterLayout alloc] init];
    self.layout = layout;
    layout.numberOfCol = 2;
    layout.rowPanding = 0;
    layout.colPanding = 12;
    layout.headerViewHeight = _headerVC.viewHeight + kPhotoDetailSectionHeaderViewHeight;
    layout.sectionInset = UIEdgeInsetsMake(0, 12, 12 + kRKBWIDTH(50), 12);
    layout.delegate = self;
    [layout autuContentSize];
    
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindWaterfallCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FindWaterfallCollectionViewCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoDetailSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoDetailSectionHeaderView"];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)loadNetworkData {
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            self.headerVC.commentArray = self.recordPageRequest.responseInfo.items;
            if (self.layout) {
                self.layout.headerViewHeight = self.headerVC.viewHeight + kPhotoDetailSectionHeaderViewHeight;
                self.collectionView.collectionViewLayout = self.layout;
            }
            [self.collectionView reloadData];
            
            [self refreshBottomViewUI];
        }
    }];
}

- (void)refreshBottomViewUI {
    NSInteger count = _store.arcInfo.assemarcnumcomm;
    count = count < self.recordPageRequest.responseInfo.items.count ? self.recordPageRequest.responseInfo.items.count : count;
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"%td",count];
    if (_store.arcInfo.assemarcnumcomm == 0) {
        self.commentCountLabel.hidden = YES;
    } else {
        self.commentCountLabel.hidden = NO;
    }
    
    self.zanCountLabel.text = [NSString stringWithFormat:@"%td",_store.arcInfo.assemarcnumzan];
    self.zanImageView.image = self.store.arcInfo.assemarciszan ? [UIImage imageNamed:@"find_article_has_like"] : [UIImage imageNamed:@"find_article_no_like"];
}

#pragma mark - Getters & Setters

- (FindCommentPageRequest *)recordPageRequest {
    if (!_recordPageRequest) {
        _recordPageRequest = [[FindCommentPageRequest alloc] init];
        _recordPageRequest.assemId = _store.arcInfo.assemarcid;
        _recordPageRequest.rankType = CommentRankType_D;
    }
    return _recordPageRequest;
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
    NSString *url = _store.arcInfo.linkshare;
    NSString *title = @"我在【有数啦】发布了有趣的图片，快来围观吧！";
    if (tag == SHARE_TYPE_WEIBO) {
        title = [NSString stringWithFormat:@"%@%@", title, url];
    }
    NSString *content = @"等你来哦~";
    NSString *image = _store.arcInfo.urlshare;
    [[[UMShareManager alloc]init] webShare:tag title:title content:content
                                       url:_store.arcInfo.linkshare image:image complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(8),@"typeid":@(self.store.arcInfo.assemarcid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
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

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.store.isEmptyData) {
        return 1; //占位符， 反正header无法滑动
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
        FindAssemarcInfo *arcInfo = [self.store assemarcInfoWithIndexPath:indexPath];
        [self clickZan:arcInfo model:model indexPath:indexPath];
    };
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        PhotoDetailSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoDetailSectionHeaderView" forIndexPath:indexPath];
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

#pragma mark FindPhotoDetailHeaderViewControllerDelegate
- (void)findPhotoDetailHeaderViewController:(FindPhotoDetailHeaderViewController *)controller clickContentImageViewWithViewModel:(FindAssemarcFileJA *)dataModel;
{
    FindAssemarcFileJA *info = dataModel;
    NSInteger index = [self.store.arcInfo.assemarcfileJA indexOfObject:info];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemarcFileJA *file in self.store.arcInfo.assemarcfileJA)
    {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageUrl = file.assemarcfileurl;
        model.labelModelList = file.assemarcfiletagJA;
        [result addObject:model];
    }
    
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:result showIndex:index arcInfo:self.store.arcInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
