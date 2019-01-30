//
//  DiscoverySquareViewController.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "DiscoverySquareViewController.h"

#import "NoneContentCell.h"
#import "NoneContentViewModel.h"

#import "LeftRightLabelCell.h"
#import "LeftRightLabelViewModel.h"

#import "MoreCollectionCell.h"
#import "MoreCollectionViewModel.h"

#import "CollectionDetailView.h"
#import "CollectionDetailViewModel.h"

#import "AuthorCell.h"
#import "AuthorViewModel.h"

#import "MoreLineLabelCell.h"
#import "MoreLineLabelViewModel.h"

#import "OnePictureCell.h"
#import "OnePictureViewModel.h"

#import "TwoPictureCell.h"
#import "TwoPictureViewModel.h"

#import "ThreePictureCell.h"
#import "ThreePictureViewModel.h"

#import "OperatedIconCell.h"
#import "OperatedIconViewModel.h"

#import "MorelLineLabelWithBackgroundCell.h"
#import "MorelLineLabelWithBackgroundViewModel.h"

#import "AdvertisementsOptionImageCell.h"
#import "AdvertisementsOptionImageViewModel.h"

#import "SwitchOptionsView.h"
#import "SwitchOptionsViewModel.h"

#import "BaseCellLineViewModel.h"

#import "TTTAttributedLabel.h"

#import "FindAssemListViewController.h"
#import "AssemDetailContainerViewController.h"

#import "UIViewController+YHToast.h"

#import "UnReadManager.h"

#import "FindAssemActivityInfo.h"
#import "FindAssemarcInfo.h"

#import "MineFindMainOtherViewController.h"

#import "FindPhotoDetailViewController.h"

#import "FindArticleDetailViewController.h"

#import "FindPhotoPreviewViewController.h"

#import "AssemarcRequest.h"

#import "GBSharePan.h"

#import "DiscoveryListDataModel.h"

#import "WebViewController.h"
#import "Login.h"
 
#import "ZFPlayer.h"

#import "TableviewListIsEmptyViewModel.h"
#import "TableviewListIsEmptyCell.h"

#import "PersonProfileViewController.h"

#define kMaxLine 4
#define kShareViewIndexSectionKey @"kShareViewIndexSectionKey"
#define kLineSpace 10
#define kTextFont 14


typedef NS_ENUM(NSInteger , DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE) {
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ALLCOLLECTION,//美家征集 -> 查看全部
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS,//广告
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE,//发现用户发的文章
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY,//发现用户发的照片
    DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_SHOWALL//显示全部
};

#define kMaxCount 20

@interface DiscoverySquareViewController () <UITableViewDelegate,UITableViewDataSource,MoreCollectionCellDelegate,GBSharePanDelegate>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) NSMutableArray *assemarcDataSource;//美家征集
@property (nonatomic, strong) NSMutableArray *discoveryDataSources;//发现数据
@property (nonatomic, strong) NSMutableArray *advertisementsDataSources;//广告数据
@property (nonatomic, strong) NSMutableArray *sortRules;
@property (nonatomic, strong) ZFPlayerView   *player;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation DiscoverySquareViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUIInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player resetPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UnReadManager shareManager] updateUnRead];
    
    [self setupData];
}

- (void)setupData
{
    [[TiHouse_NetAPIManager sharedManager] request_assemListUsingBlock:^(NSArray *data, NSError *error) {
        [self.assemarcDataSource removeAllObjects];
        [self.assemarcDataSource addObjectsFromArray:data];
        [self resetViewModelWithShouldRemoveAll:NO dataModel:[NSArray array]];
    }];
    
    [self reloadData];
}

- (void)reloadData
{
    WEAKSELF;
    [[TiHouse_NetAPIManager sharedManager] request_discoveryListWithPage:0 UsingBlock:^(DiscoveryListDataModel * dataModel, NSError *error) {
        [weakSelf.table.mj_header endRefreshing];
        if (!error)
        {
            [weakSelf.discoveryDataSources removeAllObjects];
            [weakSelf.advertisementsDataSources removeLastObject];
            [weakSelf.sortRules removeAllObjects];
            
            [weakSelf.discoveryDataSources addObjectsFromArray:dataModel.assemarcList];
            
            if (dataModel.assemadvertList && dataModel.assemadvertList.count > 0)
            {
                [weakSelf.advertisementsDataSources addObjectsFromArray:dataModel.assemadvertList];
            }
            if (dataModel.sortRules && dataModel.sortRules.count > 0)
            {
                [weakSelf.sortRules addObjectsFromArray:dataModel.sortRules];
            }
            
            [weakSelf resetViewModelWithShouldRemoveAll:YES dataModel:[self organizedDiscoveryList]];
            weakSelf.table.mj_footer.hidden = dataModel.assemarcList.count < 20;
        }
    }];
}

- (void)loadMoreData
{
    WEAKSELF;
    [[TiHouse_NetAPIManager sharedManager] request_discoveryListWithPage:self.discoveryDataSources.count UsingBlock:^(DiscoveryListDataModel * dataModel, NSError *error) {
        [weakSelf.table.mj_footer endRefreshing];
        if (!error)
        {
            if (dataModel.assemarcList && dataModel.assemarcList.count > 0)
            {
                [weakSelf.discoveryDataSources addObjectsFromArray:dataModel.assemarcList];
            }
            
            [weakSelf resetViewModelWithShouldRemoveAll:YES dataModel:[self organizedDiscoveryList]];
            
            weakSelf.table.mj_footer.hidden = dataModel.assemarcList.count < 20;
        }
    }];
}

- (void)resetViewModelWithShouldRemoveAll:(BOOL)shouldRemoveAllFirst dataModel:(NSArray *)dataModelArray
{
    if (shouldRemoveAllFirst)
    {
        [self.viewModels removeAllObjects];
    }
    
    BOOL hasAssemrac = NO;
    for (NSArray *tmpArray in self.viewModels)
    {
        for (BaseViewModel *tmpViewModel in tmpArray)
        {
            if (tmpViewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ALLCOLLECTION)
            {
                hasAssemrac = YES;
                break;
            }
        }
    }
    
    NSMutableArray *sectionArray;
    if (self.assemarcDataSource && self.assemarcDataSource.count > 0 && !hasAssemrac)//如果有美家征集
    {
        sectionArray = [NSMutableArray array];
        [sectionArray addObject:[self leftRightLabelViewModel]];
        [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
        MoreCollectionViewModel *collectionViewModel = (MoreCollectionViewModel *)[self moreCollectionViewModel];
        for (int i = 0 ; i < self.assemarcDataSource.count; i++)
        {
            FindAssemActivityInfo *assDataModel = self.assemarcDataSource[i];
            [collectionViewModel.collections addObject:[self collectionDetailViewModelWithImageUrl:assDataModel.assemurlindex title:assDataModel.assemtitle dataModel:assDataModel]];
        }
        [sectionArray addObject:collectionViewModel];
        [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
        [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
        [self.viewModels addObject:sectionArray];
    }
    
    if (dataModelArray && dataModelArray.count > 0)//如果有数据
    {
        for (int i = 0; i < dataModelArray.count; i++)
        {
            sectionArray = [NSMutableArray array];
            id model = dataModelArray[i];
            if ([model isKindOfClass:[FindAssemarcInfo class]])
            {
                FindAssemarcInfo *dataModel = model;
                DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT;//是否是文章 还是图片类型
                BOOL hasShowAllButton = NO;//是否有全文
                UIImage *operatedFirstImage = nil;
                NSString *operatedFirstTitle = nil;
                
                UIImage *operatedSecondImage = nil;
                NSString *operatedSecondTitle = nil;
                
                UIImage *operatedThirdImage = nil;
                NSString *operatedThirdTitle = nil;
                
                NSString *topic = dataModel.assemtitle.length > 0 ? [NSString stringWithFormat:@"#%@#  ",dataModel.assemtitle]: @"";
                NSString *moreLineText = [NSString stringWithFormat:@"%@%@",topic,dataModel.assemarctitle];
                
                BOOL hasRightButton = YES;//是否有关注按钮
                if (dataModel.assemarcuid == [Login curLoginUserID])
                {
                    hasRightButton = NO;
                }
    
                if (dataModel.assemarctype == 1)//文章
                {
                    cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE;
                    operatedFirstImage = dataModel.assemarciszan ? [UIImage imageNamed:@"find_root_has_like"] : [UIImage imageNamed:@"find_root_like"];
                    operatedFirstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                    operatedSecondImage = dataModel.assemarciscoll ? [UIImage imageNamed:@"find_root_has_collection"] : [UIImage imageNamed:@"find_root_collection"];
                    operatedSecondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcoll];
                    operatedThirdImage = [UIImage imageNamed:@"find_root_comment"];
                    operatedThirdTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcomm];
                }
                else if (dataModel.assemarctype == 2)//图片
                {
                    cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY;
                    operatedFirstImage = dataModel.assemarciszan ? [UIImage imageNamed:@"find_root_has_like"] : [UIImage imageNamed:@"find_root_like"];
                    operatedFirstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                    operatedSecondImage = [UIImage imageNamed:@"find_root_comment"];
                    operatedSecondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcomm];
                }
                
                float maxTextHeight = [self textHeightWithText:moreLineText numberOfLine:0];
                float textHeight = [self textHeightWithText:moreLineText numberOfLine:4];
                if (maxTextHeight > textHeight)
                {
                    hasShowAllButton = YES;
                }
                
                if (1)//如果有作者信息
                {
                    [sectionArray addObject:[self authorViewModelWithImageUrl:dataModel.urlhead topTitle:dataModel.username bottomTitle:dataModel.createtimeStr rightButtonCanTouch:!dataModel.assemarcisconcern dataModel:dataModel cellType:cellType hasRightButton:hasRightButton]];
                    [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:cellType dataModel:dataModel]];
                }
                
                if (cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY)//如果是发现的照片
                {
                    if (moreLineText.length > 0)//如果有文字
                    {
                        [sectionArray addObject:[self moreLineLabelViewModelWithText:moreLineText textColor:RGB(0, 0, 0) lineNumber:kMaxLine cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY dataModel:dataModel topicString:topic]];
                        if (hasShowAllButton)
                        {
                            [sectionArray addObject:[self emptyModelWithHeight:20 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:cellType dataModel:dataModel]];
                            [sectionArray addObject:[self moreLineLabelViewModelWithText:@"全文" textColor:RGB(83, 134, 168) lineNumber:1 cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_SHOWALL dataModel:dataModel topicString:@""]];
                        }
                        [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:cellType dataModel:dataModel]];
                    }
                    
                    if (dataModel.assemarcfileJA.count && dataModel.assemarcfileJA.count > 0)//如果有照片
                    {
                        if (dataModel.assemarcfileJA.count == 1)//照片只有1张
                        {
                            FindAssemarcFileJA *photoDataModel = dataModel.assemarcfileJA[0];
                            [sectionArray addObject:[self onePictureViewModelWithImageUrl:photoDataModel.assemarcfileurl dataModel:dataModel]];
                        }
                        else if (dataModel.assemarcfileJA.count == 2)//照片只有2张
                        {
                            FindAssemarcFileJA *firstPhotoDataModel = dataModel.assemarcfileJA[0];
                            FindAssemarcFileJA *secondPhotoDataMoel = dataModel.assemarcfileJA[1];
                            [sectionArray addObject:[self twoPictureViewModelWithFirstImageUrl:firstPhotoDataModel.assemarcfileurl secondImageUrl:secondPhotoDataMoel.assemarcfileurl dataModel:dataModel]];
                        }
                        else//大于等于3张
                        {
                            NSInteger count = dataModel.assemarcfileJA.count % 3 == 0 ? dataModel.assemarcfileJA.count / 3: dataModel.assemarcfileJA.count / 3 + 1;
                            NSInteger countPlus = 0;//自增的行数
                            for (int i = 0 ; i < count; i++)
                            {
                                NSString *firstImageUrl = dataModel.assemarcfileJA.count > countPlus * 3 + 0 ? [[dataModel.assemarcfileJA objectAtIndex:(countPlus * 3 + 0)] assemarcfileurl] : @"";
                                NSString *secondImageUrl = dataModel.assemarcfileJA.count > countPlus * 3 + 1 ? [[dataModel.assemarcfileJA objectAtIndex:(countPlus * 3 + 1)] assemarcfileurl] : @"";
                                NSString *thirdImageUrl = dataModel.assemarcfileJA.count > countPlus * 3 + 2 ? [[dataModel.assemarcfileJA objectAtIndex:(countPlus * 3 + 2)] assemarcfileurl] : @"";
                                //count = 0 ; 左 count = 1 中 ； count = 2右 累加的形式
                                [sectionArray addObject:[self threePictureViewModel:firstImageUrl secondImageUrl:secondImageUrl thirdImageUrl:thirdImageUrl dataModel:dataModel index:countPlus]];
                                [sectionArray addObject:[self emptyModelWithHeight:2 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
                                countPlus++;
                            }
                        }
                    }
                }
                else if (cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE)//如果是文章
                {
                    [sectionArray addObject:[self advertisementsOptionImageViewModelWithImageUrl:dataModel.urlindex cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE dataModel:dataModel hasTopImage:NO]];
                    [sectionArray addObject:[self morelLineLabelWithBackgroundViewModelWithText:dataModel.assemarctitle font:kTextFont textColor:RGB(0, 0, 0) dataModel:dataModel]];
                }
                
                if (cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE || cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY)//如果有操作栏
                {
                    [sectionArray addObject:[self operatedIconViewModelWithFirstImage:operatedFirstImage firstTitle:operatedFirstTitle secondImage:operatedSecondImage secondTitle:operatedSecondTitle thirdImage:operatedThirdImage thirdTitle:operatedThirdTitle dataModel:dataModel cellType:cellType]];
                }
                
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
            }
            else if ([model isKindOfClass:[DiscoveryAdvertisementsDataModel class]]) //如果是广告
            {
                DiscoveryAdvertisementsDataModel *dataModel = model;
                NSString *url = [dataModel.assemadverttype integerValue] == 1 ? dataModel.urlfile: dataModel.urlfilesmall;//1是图片 2是视频
                NSString *province = dataModel.provname.length > 0 ? [NSString stringWithFormat:@"%@  ",dataModel.provname]: @"";
                NSString *city = dataModel.cityname.length > 0 ? [NSString stringWithFormat:@"%@  ",dataModel.cityname]: @"";
                NSString *region = dataModel.regionname.length > 0 ? [NSString stringWithFormat:@"%@  ",dataModel.regionname]: @"";
                BOOL hasTopImage = [dataModel.assemadverttype integerValue] == 1 ? NO: YES;//是否是视频
                
                NSString *bottomTitle = [NSString stringWithFormat:@"%@%@%@",province,city,region];
                [sectionArray addObject:[self authorViewModelWithImageUrl:dataModel.urllogo topTitle:dataModel.assemadvertname bottomTitle:bottomTitle dataModel:dataModel]];
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel]];
                [sectionArray addObject:[self moreLineLabelViewModelWithText:dataModel.assemadvertdesc textColor:RGB(0, 0, 0) lineNumber:0 cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel topicString:@""]];
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel]];
                [sectionArray addObject:[self advertisementsOptionImageViewModelWithImageUrl:url cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel hasTopImage:hasTopImage]];
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel]];
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS dataModel:dataModel]];
            }
            [self.viewModels addObject:sectionArray];
        }
    }
    
    
    if (self.viewModels.count == 0)
    {
        sectionArray = [NSMutableArray array];
        //填充空白数据
        [sectionArray addObject:[self tableviewListIsEmptyViewModel]];
        [self.viewModels addObject:sectionArray];
    }
    
    [self.table reloadData];
}


- (void)setupUIInterface
{
    self.title = @"发现首页_动态";
    
    self.table = [KitFactory tableView];
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight - kTABBARH);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.table.mj_footer.hidden = YES;
    
    [self.table registerClass:[NoneContentCell class] forCellReuseIdentifier:NSStringFromClass([NoneContentCell class])];
    [self.table registerClass:[LeftRightLabelCell class] forCellReuseIdentifier:NSStringFromClass([LeftRightLabelCell class])];
    [self.table registerClass:[MoreCollectionCell class] forCellReuseIdentifier:NSStringFromClass([MoreCollectionCell class])];
    [self.table registerClass:[AuthorCell class] forCellReuseIdentifier:NSStringFromClass([AuthorCell class])];
    [self.table registerClass:[MoreLineLabelCell class] forCellReuseIdentifier:NSStringFromClass([MoreLineLabelCell class])];
    [self.table registerClass:[OnePictureCell class] forCellReuseIdentifier:NSStringFromClass([OnePictureCell class])];
    [self.table registerClass:[TwoPictureCell class] forCellReuseIdentifier:NSStringFromClass([TwoPictureCell class])];
    [self.table registerClass:[OperatedIconCell class] forCellReuseIdentifier:NSStringFromClass([OperatedIconCell class])];
    [self.table registerClass:[MorelLineLabelWithBackgroundCell class] forCellReuseIdentifier:NSStringFromClass([MorelLineLabelWithBackgroundCell class])];
    [self.table registerClass:[AdvertisementsOptionImageCell class] forCellReuseIdentifier:NSStringFromClass([AdvertisementsOptionImageCell class])];
    [self.table registerClass:[ThreePictureCell class] forCellReuseIdentifier:NSStringFromClass([ThreePictureCell class])];
    [self.table registerClass:[TableviewListIsEmptyCell class] forCellReuseIdentifier:NSStringFromClass([TableviewListIsEmptyCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModels[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionViewModel = self.viewModels[indexPath.section];
    BaseViewModel *viewModel = sectionViewModel[indexPath.row];
    BaseTableViewCell *cell  = [self.table dequeueReusableCellWithIdentifier:viewModel.cellIndentifier];
    cell.delegate = self;
    [cell resetCellWithViewModel:viewModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionViewModel = self.viewModels[indexPath.section];
    BaseViewModel *viewModel = sectionViewModel[indexPath.row];
    if (viewModel.currentCellHeight == 0)
    {
        viewModel.currentCellHeight = [viewModel.cellClass currentCellHeightWithViewModel:viewModel];
    }
    return viewModel.currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionViewModel = self.viewModels[indexPath.section];
    BaseViewModel *viewModel = sectionViewModel[indexPath.row];
    id model = viewModel.dataModel;
    if (viewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ALLCOLLECTION)//美家征集 -> 查看全部
    {
        FindAssemListViewController *vc = [[FindAssemListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ((viewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY || viewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE) && [model isKindOfClass:[FindAssemarcInfo class]])//如果是文章或者照片
    {
        FindAssemarcInfo *dataModel = model;
        if (dataModel)
        {
            //文章
            if (dataModel.assemarctype == 1)
            {
                FindArticleDetailViewController *findArticleDetailViewController = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:dataModel];
                [self.navigationController pushViewController:findArticleDetailViewController animated:YES];
            }
            //图片
            else if (dataModel.assemarctype == 2)
            {
                FindPhotoDetailViewController *detailViewController = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:dataModel];
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
        }
    }
    else if (viewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_SHOWALL)//全文
    {
        MoreLineLabelViewModel *moreTextViewModel = sectionViewModel[indexPath.row - 2];//文本viewmodel
        MoreLineLabelViewModel *showAllViewModel;//全文viewmodel
        for (BaseViewModel *tmpViewModel in sectionViewModel)
        {
            if (tmpViewModel == moreTextViewModel)
            {
                if (moreTextViewModel.lineNumber == 0)//如果已经是展开全部 那么代表点击是收起
                {
                    float maxTextHeight = [self textHeightWithText:moreTextViewModel.text numberOfLine:kMaxLine];
                    MoreLineLabelViewModel *moreLineViewModel = (MoreLineLabelViewModel *)tmpViewModel;
                    moreLineViewModel.lineNumber = kMaxLine;
                    moreLineViewModel.currentCellHeight = maxTextHeight;
                }
                else //如果是收起 那么代表点击是全文
                {
                    float maxTextHeight = [self textHeightWithText:moreTextViewModel.text numberOfLine:0];
                    MoreLineLabelViewModel *moreLineViewModel = (MoreLineLabelViewModel *)tmpViewModel;
                    moreLineViewModel.lineNumber = 0;
                    moreLineViewModel.currentCellHeight = maxTextHeight;
                }
            }
            else if (tmpViewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_SHOWALL)
            {
                if (moreTextViewModel.lineNumber == 0)//如果已经是展开全部 那么代表点击是收起
                {
                    showAllViewModel = (MoreLineLabelViewModel *)tmpViewModel;
                    showAllViewModel.text = @"收起";
                }
                else //如果是收起 那么代表点击是全文
                {
                    showAllViewModel = (MoreLineLabelViewModel *)tmpViewModel;
                    showAllViewModel.text = @"全文";
                }
            }
        } 
        [self.table reloadData];
    }
    else if (viewModel.cellType == DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS && [model isKindOfClass:[DiscoveryAdvertisementsDataModel class]])//如果是广告
    {
        DiscoveryAdvertisementsDataModel *dataModel = model;
        
        if ([dataModel.assemadverttype integerValue] == 2 && [viewModel isKindOfClass:[AdvertisementsOptionImageViewModel class]])//视频
        {
            if (dataModel.urlfile.length > 0)
            {
                AdvertisementsOptionImageCell *cell = [self.table cellForRowAtIndexPath:indexPath];
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.title            = dataModel.assemadvertname;
                playerModel.videoURL         = [NSURL URLWithString:dataModel.urlfile];
                playerModel.placeholderImageURLString = dataModel.urlfilesmall;
                playerModel.scrollView       = self.table;
                playerModel.indexPath        = indexPath;
                // player的父视图tag
                playerModel.fatherViewTag    = cell.largeImage.tag;
//                playerModel.seekTime         = 0;
                
                [self.player playerControlView:nil playerModel:playerModel];
                [self.player autoPlayTheVideo];
            }
        }
        else  //非视频viewModel
        {
            if (dataModel.allurllink.length > 0)
            {
                WebViewController *webViewController = [[WebViewController alloc] init];
                webViewController.webSite = dataModel.allurllink;
                webViewController.adverttype = dataModel.adverttype;
                webViewController.advertid = dataModel.assemadvertid;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
        }
    }
}

#pragma mark LazyInit
- (NSMutableArray *)viewModels
{
    if (!_viewModels)
    {
        _viewModels = [[NSMutableArray alloc] init];
    }
    return _viewModels;
}

- (ZFPlayerView *)player
{
    if (!_player)
    {
        _player = [ZFPlayerView sharedPlayerView];
        _player.cellPlayerOnCenter = NO;
        _player.forcePortrait = NO;
        _player.disablePanGesture = NO;
        _player.hasPreviewView = YES;
        _player.stopPlayWhileCellNotVisable = YES;
    }
    return _player;
}

- (NSMutableArray *)assemarcDataSource
{
    if (!_assemarcDataSource)
    {
        _assemarcDataSource = [NSMutableArray array];
    }
    return _assemarcDataSource;
}

- (NSMutableArray *)discoveryDataSources
{
    if (!_discoveryDataSources)
    {
        _discoveryDataSources = [NSMutableArray array];
    }
    return _discoveryDataSources;
}

- (NSMutableArray *)advertisementsDataSources
{
    if (!_advertisementsDataSources)
    {
        _advertisementsDataSources = [NSMutableArray array];
    }
    return _advertisementsDataSources;
}

- (NSMutableArray *)sortRules
{
    if (!_sortRules)
    {
        _sortRules = [NSMutableArray array];
    }
    return _sortRules;
}

- (BaseViewModel *)leftRightLabelViewModel
{
    LeftRightLabelViewModel *viewModel = [[LeftRightLabelViewModel alloc] init];
    viewModel.cellClass = [LeftRightLabelCell class];
    viewModel.currentCellHeight = 40;
    viewModel.leftTitle = @"美家征集";
    viewModel.rightTitle = @"查看全部";
    viewModel.cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ALLCOLLECTION;
    viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    return viewModel;
}

- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor cellType:(DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel
{
    NoneContentViewModel *viewModel = [[NoneContentViewModel alloc] init];
    viewModel.cellBackgroundColor   = backgroundColor;
    viewModel.cellClass             = [NoneContentCell class];
    viewModel.currentCellHeight     = height;
    if (hasBottomLine)
    {
        viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    viewModel.cellType = cellType;
    viewModel.dataModel = dataModel;
    return viewModel;
}

- (BaseViewModel *)collectionDetailViewModelWithImageUrl:(NSString *)imageUrl title:(NSString *)title dataModel:(id)dataModel
{
    CollectionDetailViewModel *viewModel = [[CollectionDetailViewModel alloc] init];
    viewModel.imgUrl = imageUrl;
    viewModel.dataModel = dataModel;
    viewModel.bottomTitle = title;
    viewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
    return viewModel;
}

- (BaseViewModel *)moreCollectionViewModel
{
    MoreCollectionViewModel *viewModel = [[MoreCollectionViewModel alloc] init];
    viewModel.currentCellHeight = kRKBHEIGHT(100);
    viewModel.collections = [NSMutableArray array];
    viewModel.cellClass = [MoreCollectionCell class];
    return viewModel;
}

- (BaseViewModel *)authorViewModelWithImageUrl:(NSString *)imageUrl topTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle rightButtonCanTouch:(BOOL)rightButtonCanTouch dataModel:(id)dataModel cellType:(NSInteger)cellType hasRightButton:(BOOL)hasRightButton
{
    AuthorViewModel *viewModel = [[AuthorViewModel alloc] init];
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.topTitle = topTitle;
    viewModel.bottomTitle = bottomTitle;
    viewModel.type = AUTHORVIEWMODELTYPE_CONCERNTYPE;
    viewModel.buttonCanTouch = rightButtonCanTouch;
    viewModel.cellType = cellType;
    viewModel.hasRightButton = hasRightButton;
    if (rightButtonCanTouch)
    {
        viewModel.buttonTitle = @"➕关注";
        viewModel.buttonBackgroundColor = RGB(253, 240, 134);
        viewModel.buttonTextColor = RGB(96, 96, 96);
    }
    else
    {
        viewModel.buttonTitle = @"已关注";
        viewModel.buttonBackgroundColor = RGB(239, 239, 239);
        viewModel.buttonTextColor = RGB(96, 96, 96);
    }
    viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    viewModel.currentCellHeight = 56;
    viewModel.cellClass = [AuthorCell class];
    viewModel.dataModel = dataModel;
    return viewModel;
}

- (BaseViewModel *)authorViewModelWithImageUrl:(NSString *)imageUrl topTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle dataModel:(id)dataModel
{
    AuthorViewModel *viewModel = [[AuthorViewModel alloc] init];
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.topTitle = topTitle;
    viewModel.bottomTitle = bottomTitle;
    viewModel.type = AUTHORVIEWMODELTYPE_ADVERTISEMENTSTYPE;
    viewModel.currentCellHeight = 56;
    viewModel.cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS;
    viewModel.cellClass = [AuthorCell class];
    viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    viewModel.dataModel = dataModel;
    viewModel.hasRightButton = YES;
    return viewModel;
}

- (BaseViewModel *)onePictureViewModelWithImageUrl:(NSString *)imageUrl dataModel:(FindAssemarcInfo *)dataModel
{
    OnePictureViewModel *viewModel = [[OnePictureViewModel alloc] init];
    viewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.imgUrl = imageUrl;
    viewModel.cellClass = [OnePictureCell class];
    viewModel.currentCellHeight = [[dataModel.assemarcfileJA objectAtIndex:0] assemarcfileh] > self.view.frame.size.width - 10 * 2 ? self.view.frame.size.width - 10 * 2: [dataModel.assemarcfileJA[0] assemarcfileh];
    viewModel.dataModel = dataModel;
    viewModel.hasTopRightIcon = NO;
    if ([[dataModel.assemarcfileJA[0] assemarcfiletagJA] count] > 0)
    {
        viewModel.hasTopRightIcon = YES;
    }
    viewModel.topRightIcon = [UIImage imageNamed:@"sign"];
    return viewModel;
}

- (BaseViewModel *)moreLineLabelViewModelWithText:(NSString *)text textColor:(UIColor *)textColor lineNumber:(NSInteger)lineNumber cellType:(DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel topicString:(NSString *)topicStirng
{
    MoreLineLabelViewModel *viewModel = [[MoreLineLabelViewModel alloc] init];
    viewModel.text = text;
    viewModel.font = kTextFont;
    viewModel.textColor = textColor;
    viewModel.textAlignment = NSTextAlignmentLeft;
    viewModel.lineNumber = lineNumber;
    viewModel.canCopy = YES;
    viewModel.cellClass = [MoreLineLabelCell class];
    viewModel.leftSpace = 10;
    viewModel.rightSpace = 10;
    float textHeight = [self textHeightWithText:text numberOfLine:lineNumber];
    viewModel.currentCellHeight = textHeight;
    viewModel.dataModel = dataModel;
    viewModel.cellType = cellType;
    viewModel.topicString = topicStirng;
    return viewModel;
}

- (BaseViewModel *)twoPictureViewModelWithFirstImageUrl:(NSString *)imageUrl secondImageUrl:(NSString *)secondImageUrl dataModel:(FindAssemarcInfo *)dataModel
{
    TwoPictureViewModel *viewModel = [[TwoPictureViewModel alloc] init];
    viewModel.firstPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.firstImageUrl = imageUrl;
    viewModel.secondPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.secondImageUrl = secondImageUrl;
    viewModel.cellClass = [TwoPictureCell class];
    viewModel.currentCellHeight =  (self.view.frame.size.width - 10 * 2 - 6 )/ 2;
    viewModel.dataModel = dataModel;
    viewModel.hasTopLeftIcon = [[dataModel.assemarcfileJA[0] assemarcfiletagJA] count] > 0;
    viewModel.hasTopRightIcon = [[dataModel.assemarcfileJA[1] assemarcfiletagJA] count] > 0;
    viewModel.topLeftIcon = [UIImage imageNamed:@"sign"];
    viewModel.topRightIcon = [UIImage imageNamed:@"sign"];
    viewModel.cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY;
    return viewModel;
}

- (BaseViewModel *)threePictureViewModel:(NSString *)imageUrl secondImageUrl:(NSString *)secondImageUrl thirdImageUrl:(NSString *)thirdImageUrl dataModel:(FindAssemarcInfo *)dataModel index:(NSInteger)index
{
    ThreePictureViewModel *viewModel = [[ThreePictureViewModel alloc] init];
    viewModel.firstPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.firstImageUrl = imageUrl;
    viewModel.secondPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.secondImageUrl = secondImageUrl;
    viewModel.thirdImageUrl = thirdImageUrl;
    viewModel.thirdPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.cellClass = [ThreePictureCell class];
    viewModel.currentCellHeight =  (self.view.frame.size.width - 10 * 2 - 2 * 2) / 3;
    viewModel.dataModel = dataModel;
    BOOL firstIconShouldShow = NO;
    BOOL secondIconShouldShow = NO;
    BOOL thirdIconShouldShow = NO;
    viewModel.firstTopIcon = [UIImage imageNamed:@"sign"];
    viewModel.secondTopIcon = [UIImage imageNamed:@"sign"];
    viewModel.thirdTopIcon = [UIImage imageNamed:@"sign"];
    if (dataModel.assemarcfileJA.count > index*3)
    {
        firstIconShouldShow = [[dataModel.assemarcfileJA[index*3] assemarcfiletagJA] count] > 0;
    }
    
    if (dataModel.assemarcfileJA.count > index*3+1)
    {
        secondIconShouldShow = [[dataModel.assemarcfileJA[index*3+1] assemarcfiletagJA] count] > 0;
    }
    
    if (dataModel.assemarcfileJA.count > index*3+2)
    {
        thirdIconShouldShow = [[dataModel.assemarcfileJA[index*3+2] assemarcfiletagJA] count] > 0;
    }
    
    viewModel.hasFirstTopIcon = firstIconShouldShow;
    viewModel.hasSecondTopIcon = secondIconShouldShow;
    viewModel.hasThirdTopIcon = thirdIconShouldShow;
    viewModel.countRowIndex = index;//代表是第几张
    viewModel.cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_DISCORVERY;
    return viewModel;
}

- (BaseViewModel *)operatedIconViewModelWithFirstImage:(UIImage *)fImage firstTitle:(NSString *)fTitle secondImage:(UIImage *)sImage secondTitle:(NSString *)sTitle thirdImage:(UIImage *)tImage thirdTitle:(NSString *)tTitle dataModel:(id)dataModel cellType:(DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE)cellType
{
    OperatedIconViewModel *viewModel = [[OperatedIconViewModel alloc] init];
    viewModel.currentCellHeight = 50;
    viewModel.cellClass = [OperatedIconCell class];
    viewModel.firstIcon = fImage;
    viewModel.firstTitle = fTitle;
    viewModel.secondIcon = sImage;
    viewModel.secondTitle = sTitle;
    viewModel.thirdIcon = tImage;
    viewModel.thirdTitle = tTitle;
    viewModel.rightIcon = [UIImage imageNamed:@"nav_btn_right_share"];
    viewModel.cellType = cellType;
    viewModel.dataModel = dataModel;
    return viewModel;
}

- (BaseViewModel *)advertisementsOptionImageViewModelWithImageUrl:(NSString *)imageUrl cellType:(DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel hasTopImage:(BOOL)hasTopImage
{
    AdvertisementsOptionImageViewModel *viewModel = [[AdvertisementsOptionImageViewModel alloc] init];
    viewModel.cellClass = [AdvertisementsOptionImageCell class];
    viewModel.currentCellHeight = (self.view.frame.size.width - 10 * 2) * 9 / 16;
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolderImage = [UIImage imageNamed:@"placeHolder"];
    viewModel.cellType = cellType;
    viewModel.dataModel = dataModel;
    viewModel.topImage = hasTopImage ? [UIImage imageNamed:@"video_icon"]: nil;
    return viewModel;
}

- (BaseViewModel *)morelLineLabelWithBackgroundViewModelWithText:(NSString *)text font:(float)font textColor:(UIColor *)textColor dataModel:(id)dataModel
{
    MorelLineLabelWithBackgroundViewModel *viewModel = [[MorelLineLabelWithBackgroundViewModel alloc] init];
    viewModel.text = text;
    viewModel.font = font;
    viewModel.textColor = textColor;
    viewModel.lineNumber = 0;
    viewModel.backgroundViewColor = RGB(248, 248, 248);
    CGSize titleTextSize = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - viewModel.leftSpace - viewModel.rightSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:font]]} context:nil].size;
    viewModel.currentCellHeight = titleTextSize.height + 15 * 2;
    viewModel.cellClass = [MorelLineLabelWithBackgroundCell class];
    viewModel.moreLineLabelHeight = titleTextSize.height;
    viewModel.cellType = DISCOVERYSQUAREVIEWCONTROLLERCELLTYPE_ARTICLE;
    viewModel.dataModel = dataModel;
    return viewModel;
}

- (BaseViewModel *)tableviewListIsEmptyViewModel
{
    TableviewListIsEmptyViewModel *viewModel = [[TableviewListIsEmptyViewModel alloc] init];
    viewModel.emptyImage = [UIImage imageNamed:@"emptyTable"];
    viewModel.cellClass = [TableviewListIsEmptyCell class];
    viewModel.currentCellHeight = self.table.frame.size.height;
    return viewModel;
}

#pragma mark MoreCollectionCellDelegate
- (void)moreCollectionCell:(MoreCollectionCell *)cell clickCollectionViewWithViewModel:(CollectionDetailViewModel *)viewModel;
{
    FindAssemActivityInfo *info = viewModel.dataModel;
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark AuthorCellDelegate
- (void)authorCell:(AuthorCell *)cell clickLeftIconAndTopTitleBottomTitleWithViewModel:(AuthorViewModel *)viewModel;
{
    id model = viewModel.dataModel;
    if ([model isKindOfClass:[FindAssemarcInfo class]])
    {
        FindAssemarcInfo *dataModel = model;
        PersonProfileViewController *personProfileViewController = [[PersonProfileViewController alloc] init];
        personProfileViewController.uid = dataModel.assemarcuid;
        [self.navigationController pushViewController:personProfileViewController animated:YES];
    }
    else
    {
        DiscoveryAdvertisementsDataModel *dataModel = model;
        if (dataModel.allurllink.length > 0)
        {
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.webSite = dataModel.allurllink;
            webViewController.adverttype = dataModel.adverttype;
            webViewController.advertid = dataModel.assemadvertid;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

- (void)authorCell:(AuthorCell *)cell clickRightButtonWithViewModel :(AuthorViewModel *)viewModel;
{
    id dataModel = viewModel.dataModel;
    if ([dataModel isKindOfClass:[FindAssemarcInfo class]])//如果是文章 图片 （发现）
    {
        WEAKSELF
        [self showLoadingToast];
        __block FindAssemarcInfo *dataModel = viewModel.dataModel;
        [[TiHouse_NetAPIManager sharedManager] request_followSomeBodyWithUid:[NSString stringWithFormat:@"%ld",dataModel.assemarcuid] completedUsing:^(NSNumber *isSuccessed, NSError *error) {
            [weakSelf dismissToast];
            if ([isSuccessed boolValue])
            {
                viewModel.buttonTitle = @"已关注";
                viewModel.buttonBackgroundColor = RGB(239, 239, 239);
                viewModel.buttonTextColor = RGB(96, 96, 96);
                viewModel.buttonCanTouch = NO;
            }
            
            //下面列表所有数据 如果包含这个已关注的 要全部改成已关注
            for (NSArray *sectionArray in weakSelf.viewModels)
            {
                for (BaseViewModel *tmpViewModel in sectionArray)
                {
                    if ([tmpViewModel isKindOfClass:[AuthorViewModel class]])
                    {
                        if ([tmpViewModel.dataModel isKindOfClass:[FindAssemarcInfo class]])
                        {
                            FindAssemarcInfo *tmpDataModel = tmpViewModel.dataModel;
                            if (tmpDataModel.assemarcuid == dataModel.assemarcuid)
                            {
                                [(AuthorViewModel *)tmpViewModel setButtonTitle:@"已关注"];
                                [(AuthorViewModel *)tmpViewModel setButtonBackgroundColor:RGB(239, 239, 239)];
                                [(AuthorViewModel *)tmpViewModel setButtonTextColor:RGB(96, 96, 96)];
                                [(AuthorViewModel *)tmpViewModel setButtonCanTouch:NO];
                            }
                        }
                    }
                }
            }
            
            [weakSelf.table reloadData];
        }];
    }
    else if ([dataModel isKindOfClass:[DiscoveryAdvertisementsDataModel class]])//如果是广告
    {
        WEAKSELF;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我不感兴趣" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSInteger section = 0;
            NSMutableArray *tmpViewModels = [weakSelf.viewModels copy];
            for (int i = 0 ; i < tmpViewModels.count; i++)
            {
                NSMutableArray *tmpViewModelArray = tmpViewModels[i];
                for (int j = 0 ; j < tmpViewModelArray.count; j++)
                {
                    BaseViewModel *tmpViewModel = tmpViewModelArray[j];
                    if (tmpViewModel.dataModel == viewModel.dataModel)
                    {
                        section = i;
                        break;
                    }
                }
            }
            [self.viewModels removeObjectAtIndex:section];
            [self.table deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        [alert addAction:action];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark MoreLineLabelCellDelegate
- (void)moreLineLabelCell:(MoreLineLabelCell *)cell clickTopicStringWithViewModel:(MoreLineLabelViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemId:dataModel.assemid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark OnePictureCellDelegate
- (void)onePictureCell:(OnePictureCell *)cell clickPhotoWithViewModel:(OnePictureViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
    model.imageUrl = [dataModel.assemarcfileJA[0] assemarcfileurl];
    model.labelModelList = dataModel.assemarcfileJA[0].assemarcfiletagJA;
    
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:[NSArray arrayWithObjects:model, nil] showIndex:0 arcInfo:dataModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TwoPictureCellDelegate
- (void)twoPictureCell:(TwoPictureCell *)cell clickLeftImageWithViewModel:(TwoPictureViewModel *)viewModel;
{
    FindAssemarcInfo *info = viewModel.dataModel;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemarcFileJA *file in info.assemarcfileJA)
    {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageUrl = file.assemarcfileurl;
        model.labelModelList = file.assemarcfiletagJA;
        [result addObject:model];
    }
    
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:result showIndex:0 arcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)twoPictureCell:(TwoPictureCell *)cell clickRightImageWithViewModel:(TwoPictureViewModel *)viewModel;
{
    FindAssemarcInfo *info = viewModel.dataModel;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemarcFileJA *file in info.assemarcfileJA)
    {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageUrl = file.assemarcfileurl;
        model.labelModelList = file.assemarcfiletagJA;
        [result addObject:model];
    }
    
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:result showIndex:1 arcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ThreePictureCellDelegate
- (void)threePictureCell:(ThreePictureCell *)cell clickLeftImageWithViewModel:(ThreePictureViewModel *)viewModel;
{
    [self checkThreePhotoWithViewModel:viewModel andPhotoIndex:viewModel.countRowIndex * 3];
}

- (void)threePictureCell:(ThreePictureCell *)cell clickCenterImageWithViewModel:(ThreePictureViewModel *)viewModel;
{
    [self checkThreePhotoWithViewModel:viewModel andPhotoIndex:viewModel.countRowIndex * 3 + 1];
}

- (void)threePictureCell:(ThreePictureCell *)cell clickRightImageWithViewModel:(ThreePictureViewModel *)viewModel;
{
    [self checkThreePhotoWithViewModel:viewModel andPhotoIndex:viewModel.countRowIndex * 3 + 2];
}

#pragma mark OperatedIconCellDelegate
- (void)operatedIconCell:(OperatedIconCell *)cell clickFirstIconWithViewModel:(OperatedIconViewModel *)viewModel;
{
    __block FindAssemarcInfo *dataModel = viewModel.dataModel;
    WEAKSELF
    [self showLoadingToast];
    if (dataModel.assemarciszan)
    {
        //取消赞
        [AssemarcRequest removeAssemarcZan:dataModel.assemarcid handler:^(GBResponseInfo *model, NSError *error) {
            [weakSelf dismissToast];
            if (model.is)
            {
                dataModel.assemarciszan = 0;
                dataModel.assemarcnumzan -= 1;
                viewModel.firstIcon = [UIImage imageNamed:@"find_root_like"];
                viewModel.firstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                [weakSelf reloadOneSectionWithViewModel:viewModel];
            }
        }];
    }
    else
    {
        //去赞
        [AssemarcRequest addAssemarcZan:dataModel.assemarcid handler:^(GBResponseInfo *model, NSError *error) {
            [weakSelf dismissToast];
            if (model.is)
            {
                dataModel.assemarciszan = 1;
                dataModel.assemarcnumzan += 1;
                viewModel.firstIcon = [UIImage imageNamed:@"find_root_has_like"];
                viewModel.firstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                [weakSelf reloadOneSectionWithViewModel:viewModel];
            }
        }];
    }
}

- (void)operatedIconCell:(OperatedIconCell *)cell clickSecondIconWithViewModel:(OperatedIconViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (dataModel.assemarctype == 1)//文章
    {
        WEAKSELF
        [self showLoadingToast];
        if (dataModel.assemarciscoll == 0)
        {
            //收藏
            [AssemarcRequest addAssemarcFavor:dataModel.assemarcid handler:^(GBResponseInfo *model, NSError *error) {
                [weakSelf dismissToast];
                if (model.is)
                {
                    [self showToastWithText:@"收藏成功"];
                    dataModel.assemarciscoll = 1;
                    dataModel.assemarcnumcoll += 1;
                    viewModel.secondIcon = [UIImage imageNamed:@"find_root_has_collection"];
                    viewModel.secondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcoll];
                    [weakSelf reloadOneSectionWithViewModel:viewModel];
                }
            }];
        }
        else
        {
            //取消收藏
            [AssemarcRequest removeAssemarcFavor:dataModel.assemarcid handler:^(GBResponseInfo *model, NSError *error) {
                [weakSelf dismissToast];
                if (model.is)
                {
                    [self showToastWithText:@"取消收藏成功"];
                    dataModel.assemarciscoll = 0;
                    dataModel.assemarcnumcoll -= 1;
                    viewModel.secondIcon = [UIImage imageNamed:@"find_root_collection"];
                    viewModel.secondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcoll];
                    [weakSelf reloadOneSectionWithViewModel:viewModel];
                }
            }];
        }
    }
    else if (dataModel.assemarctype == 2)//图片
    {
        //详情
        FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:dataModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)operatedIconCell:(OperatedIconCell *)cell clickThirdIconWithViewModel:(OperatedIconViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (dataModel.assemarctype == 1)//文章
    {
        //详情
        FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:dataModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (dataModel.assemarctype == 2)//图片没有第三个按钮
    {
        return;
    }
}

- (void)operatedIconCell:(OperatedIconCell *)cell clickRightButtonWithViewModel:(OperatedIconViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    objc_setAssociatedObject(self, kShareViewIndexSectionKey, dataModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
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
// share delegate
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [self clickShare:tag];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    
    NSString *title = @"";
    NSString *subTitle = @"";
    NSString *imageUrl = nil;
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

    FindAssemarcInfo *info = objc_getAssociatedObject(self, kShareViewIndexSectionKey);
    if (!info)
    {
        return;
    }
    NSString *url = info.linkshare.length > 0 ? info.linkshare: @""; 
    if (info.assemarctype == 1)
    {
        //文章
        switch (tag)
        {
            case SHARE_TYPE_WECHAT:
            {
                title = info.assemarctitle;
                subTitle = @"【有数啦】你值得拥有的家装神器！";
            }
                break;
            case SHARE_TYPE_QQ:
            {
                title = info.assemarctitle;
                subTitle = @"【有数啦】你值得拥有的家装神器！";
            }
                break;
            case SHARE_TYPE_WEIBO:
            {
                title = [NSString stringWithFormat:@"%@%@",info.assemarctitle,url];
            }
                break;
            default:
            {
                title = info.assemarctitle;
            }
                break;
        }
        imageUrl = info.urlshare;
    }
    else
    {
        //图片
        switch (tag)
        {
            case SHARE_TYPE_CIRCLE:
            {
                title = @"我在【有数啦】发布了有趣的图片，快来围观吧！";
            }
            case SHARE_TYPE_WECHAT:
            {
                title = @"我在【有数啦】发布了有趣的图片，快来围观吧！";
                subTitle = @"等你来哦~";
            }
                break;
            case SHARE_TYPE_QQ:
            {
                title = @"我在【有数啦】发布了有趣的图片，快来围观吧！";
                subTitle = @"等你来哦~";
            }
                break;
            case SHARE_TYPE_WEIBO:
            {
                title = [NSString stringWithFormat:@"我在【有数啦】发布了有趣的图片，快来围观吧！%@",url];
            }
                break;
        }
        
        imageUrl = info.urlshare;
    }
    
    @weakify(self)
    [[[UMShareManager alloc]init] webShare:tag title:title content:subTitle
                                       url:url image:imageUrl complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
                 case 0: {
                     [NSObject showHudTipStr:@"分享成功"];
                     [self.sharePan hide:^(BOOL ok){}];
                     [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(8),@"typeid":@(info.assemarcid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                     }];
                 }break;
                 
                 case 1: {
                     [NSObject showHudTipStr:@"分享失败"];
                     [self.sharePan hide:^(BOOL ok){}];
                 }break;
             default:
                 break;
         }
     }];
}

- (void)reloadOneSectionWithViewModel:(BaseViewModel *)viewModel
{
    NSInteger section = 0;
    NSInteger row = 0;
    for (int i = 0 ; i < self.viewModels.count; i++)
    {
        NSMutableArray *tmpViewModelArray = self.viewModels[i];
        for (int j = 0 ; j < tmpViewModelArray.count; j++)
        {
            BaseViewModel *tmpViewModel = tmpViewModelArray[j];
            if (tmpViewModel == viewModel)
            {
                section = i;
                row = j;
                break;
            }
        }
    }
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (float)textHeightWithText:(NSString *)text numberOfLine:(NSInteger)line
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpace];
    
    CGFloat height = 0 ;
    CGSize size = CGSizeMake(self.view.frame.size.width - 10 * 2, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:kTextFont]],NSParagraphStyleAttributeName:paragraphStyle};
    height = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height + 2;
    if (line != 0)
    {
        return height > line * [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:kTextFont]].lineHeight + 2 + (kLineSpace * (line - 1)) ?  line * [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:kTextFont]].lineHeight + 2 + (kLineSpace * (line - 1)): height;
    }
    return height;
}

- (NSMutableArray *)organizedDiscoveryList
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.discoveryDataSources];
    NSMutableArray *tmpAdvertisementsArray = [self.advertisementsDataSources copy];
    NSMutableArray *tmpSortArray = [self.sortRules copy];
    if (self.sortRules.count == self.advertisementsDataSources.count)
    {
        for (int i = 0 ; i < tmpArray.count; i++)
        {
            for (int j = 0 ; j < tmpSortArray.count; j++)
            {
                NSString *sortIndex = tmpSortArray[j];
                NSInteger index = [sortIndex integerValue];
                if (index == i)//如果找到规则
                {
                    DiscoveryAdvertisementsDataModel *advertisementsDataModel = tmpAdvertisementsArray[j];
                    [tmpArray insertObject:advertisementsDataModel atIndex:i];
                    [self.sortRules removeObject:sortIndex];//移除规则 同步
                    [self.advertisementsDataSources removeObject:advertisementsDataModel];//移除规则 同步
                }
            }
        }
    }

    return tmpArray;
}

- (void)checkThreePhotoWithViewModel:(ThreePictureViewModel *)viewModel andPhotoIndex:(NSInteger)index
{
    FindAssemarcInfo *info = viewModel.dataModel;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemarcFileJA *file in info.assemarcfileJA)
    {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageUrl = file.assemarcfileurl;
        model.labelModelList = file.assemarcfiletagJA;
        [result addObject:model];
    }
    FindPhotoPreviewViewController *vc = [[FindPhotoPreviewViewController alloc] initWithPhotoList:result showIndex:index arcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

