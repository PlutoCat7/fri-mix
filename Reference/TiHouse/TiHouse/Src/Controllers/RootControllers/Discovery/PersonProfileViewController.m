//
//  PersonProfileViewController.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PersonProfileViewController.h"

#import "BaseViewModel.h"
#import "BaseTableViewCell.h"

#import "ProfileHeadView.h"
#import "ProfileHeadViewModel.h"

#import "ProfileOptionView.h"
#import "ProfileOptionViewModel.h"

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

#import "TableviewListIsEmptyViewModel.h"
#import "TableviewListIsEmptyCell.h"

#import "Login.h"

#import "UIViewController+HXExtension.h"

#import "PersonProfileDataModel.h"

#import "PYPhotoBrowseView.h"

#import "HXPhotoManager.h"

#import "HXCustomCameraViewController.h"
#import "HXCustomNavigationController.h"

#import "TOCropViewController.h"

#import "HXAlbumListViewController.h"

#import "UIImage+Resize.h"

#import "MineInfoViewController.h"

#import "FollowingViewController.h"
#import "FollowerViewController.h"

#import "PersonDiscoveryAndArticleViewController.h"

#define kHeadViewHeight 224
#define kSpace 10
#define kOptionViewHeight 70

#define kMaxLine 4
#define kShareViewIndexSectionKey @"kShareViewIndexSectionKey"
#define kLineSpace 10
#define kMaxCount 20

typedef NS_ENUM(NSInteger , PERSONPROFILEVIEWCONTROLLERCELLTYPE) {
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_ALLCOLLECTION,//美家征集 -> 查看全部
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS,//广告
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE,//发现用户发的文章
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY,//发现用户发的照片
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_SHOWALL,//显示全部
    PERSONPROFILEVIEWCONTROLLERCELLTYPE_OVERTHREEPICTURECELL//等于或者超过三张照片的cell
};

@interface PersonProfileViewController () <UITableViewDelegate,UITableViewDataSource,ProfileHeadViewDelegate,TOCropViewControllerDelegate,HXCustomCameraViewControllerDelegate,ProfileOptionViewDelegate>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) NSMutableArray *discoveryDataSources;

@property (nonatomic, strong) ProfileHeadView *profileView;
@property (nonatomic, strong) ProfileHeadViewModel *profileViewModel;

@property (nonatomic, strong) UIView   *headView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) ProfileOptionView *optionView;
@property (nonatomic, strong) ProfileOptionViewModel *optionViewModel;

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation PersonProfileViewController

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
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setupData];
}

- (void)setupData
{
    if (1)//如果有顶部信息
    {
        WEAKSELF
        [[TiHouse_NetAPIManager sharedManager] request_checkSomeOnesProfileWithUid:self.uid completedUsing:^(PersonProfileDataModel *data, NSError *error) {
            [self resetViewModelWithShouldRemoveAll:NO dataModel:[NSArray array]];
            
            if (!error)
            {
                [weakSelf dismissToast];
                NSString *concernedNumber = [NSString stringWithFormat:@"关注    %@",data.countconcernuid];
                NSString *beConcernedNumber = [NSString stringWithFormat:@"粉丝    %@",data.countconcernuidon];
                NSString *leftOptionText = [NSString stringWithFormat:@"图片 %@",data.countassemarctype2];
                NSString *rightOptionText = [NSString stringWithFormat:@"文章 %@",data.countassemarctype1];
                
                weakSelf.profileViewModel.dataModel = data;
                weakSelf.profileViewModel.imageUrl = data.urlhead;
                weakSelf.profileViewModel.name = data.username;
                weakSelf.profileViewModel.buttonLeftImage = [UIImage imageNamed:@"icon_conter_modify"];
                weakSelf.profileViewModel.buttonRightText = @"编辑资料";
                weakSelf.profileViewModel.hasButton = ![self isMine];
                weakSelf.profileViewModel.buttonText = [data.isConcern boolValue] ? @"已关注" : @"➕关注";//是否关注
                weakSelf.profileViewModel.buttonBackgroundColor = [data.isConcern boolValue] ? RGB(239, 239, 239) : RGB(253, 240, 134);//是否关注
                weakSelf.profileViewModel.bottomLeftTitle = concernedNumber;
                weakSelf.profileViewModel.bottomLeftAttributedTitle = data.countconcernuid;
                weakSelf.profileViewModel.bottomRightTitle = beConcernedNumber;
                weakSelf.profileViewModel.bottomRightAttributedTitle = data.countconcernuidon;
                weakSelf.profileViewModel.bottomRightImage = [self isMine] ? [UIImage imageNamed:@"icon_replace"]: nil;
                weakSelf.profileViewModel.backgroundCanTouched = [self isMine];
                weakSelf.profileViewModel.backgroundColorImage = [UIImage imageNamed:@"bg_image"];
                weakSelf.profileViewModel.backgroundColorImageUrl = data.assembgurl;
                [weakSelf.profileView resetViewWithViewModel:self.profileViewModel];
                
                weakSelf.optionViewModel.dataModel = data;
                weakSelf.optionViewModel.optionLeftTitle = leftOptionText;
                weakSelf.optionViewModel.optionRightTitle = rightOptionText;
                [weakSelf.optionView resetViewWithViewModel:weakSelf.optionViewModel];
                
                if (!weakSelf.table.tableHeaderView)
                {
                    weakSelf.table.tableHeaderView = weakSelf.headView;
                }
                
            }
        }];
    }
    
    [self reloadData];
}

- (void)reloadData
{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_articleAndDiscoveryWithUid:self.uid index:0 type:0 completedUsing:^(NSArray *data, NSError *error) {
        [weakSelf dismissToast];
        [weakSelf.table.mj_header endRefreshing];
        if (!error)
        {
            [self.table.mj_header endRefreshing];
            [self.discoveryDataSources removeAllObjects];
            [self.discoveryDataSources addObjectsFromArray:data];
            [self resetViewModelWithShouldRemoveAll:YES dataModel:data];
            self.table.mj_footer.hidden = data.count < 20;
        }
    }];
   
}

- (void)loadMoreData
{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_articleAndDiscoveryWithUid:self.uid index:self.discoveryDataSources.count type:0 completedUsing:^(NSArray *data, NSError *error) {
        [weakSelf.table.mj_footer endRefreshing];
        if (!error)
        {
            [self.table.mj_footer endRefreshing];
            [self.discoveryDataSources addObjectsFromArray:data];
            [self resetViewModelWithShouldRemoveAll:NO dataModel:data];
            self.table.mj_footer.hidden = data.count < 20;
        }
    }];
}

- (void)resetViewModelWithShouldRemoveAll:(BOOL)shouldRemoveAllFirst dataModel:(NSArray *)dataModelArray
{
    if (shouldRemoveAllFirst)
    {
        [self.viewModels removeAllObjects];
    }
    
    NSMutableArray *sectionArray;
    if (1)//如果有section 默认必须有，空数组充当section
    {
        sectionArray = [NSMutableArray array];
        [self.viewModels addObject:sectionArray];
    }
    
    if (dataModelArray && dataModelArray.count > 0)//如果有发现图文 或者 文章
    {
        sectionArray = [NSMutableArray array];
        //占位cell
        [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
        
        for (int i = 0; i < dataModelArray.count; i++)
        {
            FindAssemarcInfo *dataModel = dataModelArray[i];
            PERSONPROFILEVIEWCONTROLLERCELLTYPE cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_DEFAULT;//是否是文章 还是图片类型
            BOOL hasShowAllButton = NO;//是否有全文
            UIImage *operatedFirstImage = nil;
            NSString *operatedFirstTitle = nil;
            
            UIImage *operatedSecondImage = nil;
            NSString *operatedSecondTitle = nil;
            
            UIImage *operatedThirdImage = nil;
            NSString *operatedThirdTitle = nil;
            
            NSString *topic = dataModel.assemtitle.length > 0 ? [NSString stringWithFormat:@"#%@#  ",dataModel.assemtitle]: @"";
            NSString *moreLineText = [NSString stringWithFormat:@"%@%@",topic,dataModel.assemarctitle];
            
            if (dataModel.assemarctype == 1)//文章
            {
                cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE;
                operatedFirstImage = dataModel.assemarciszan ? [UIImage imageNamed:@"find_root_has_like"] : [UIImage imageNamed:@"find_root_like"];
                operatedFirstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                operatedSecondImage = dataModel.assemarciscoll ? [UIImage imageNamed:@"find_root_has_collection"] : [UIImage imageNamed:@"find_root_collection"];
                operatedSecondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcoll];
                operatedThirdImage = [UIImage imageNamed:@"find_root_comment"];
                operatedThirdTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcomm];
            }
            else if (dataModel.assemarctype == 2)//图片
            {
                cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY;
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
                [sectionArray addObject:[self authorViewModelWithImageUrl:dataModel.urlhead topTitle:dataModel.username bottomTitle:dataModel.createtimeStr hasRightButton:[self isMine] dataModel:dataModel]]; 
                [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:cellType dataModel:dataModel]];
            }
            
            if (cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY)//如果是发现的照片
            {
                if (moreLineText.length > 0)//如果有文字
                {
                    [sectionArray addObject:[self moreLineLabelViewModelWithText:moreLineText textColor:RGB(0, 0, 0) lineNumber:kMaxLine cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY dataModel:dataModel]];
                    if (hasShowAllButton)
                    {
                        [sectionArray addObject:[self moreLineLabelViewModelWithText:@"全文" textColor:RGB(83, 134, 168) lineNumber:1 cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_SHOWALL dataModel:dataModel]];
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
                            [sectionArray addObject:[self emptyModelWithHeight:2 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
                            countPlus++;
                        }
                    }
                }
            }
            else if (cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE)//如果是文章
            {
                [sectionArray addObject:[self advertisementsOptionImageViewModelWithImageUrl:dataModel.urlindex cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE dataModel:dataModel]];
                [sectionArray addObject:[self morelLineLabelWithBackgroundViewModelWithText:dataModel.assemarctitle font:13 textColor:RGB(0, 0, 0) dataModel:dataModel]];
            }
            
            if (cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE || cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY)//如果有操作栏
            {
                [sectionArray addObject:[self operatedIconViewModelWithFirstImage:operatedFirstImage firstTitle:operatedFirstTitle secondImage:operatedSecondImage secondTitle:operatedSecondTitle thirdImage:operatedThirdImage thirdTitle:operatedThirdTitle dataModel:dataModel cellType:cellType]];
            }
            
            [sectionArray addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:PERSONPROFILEVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];
        }
        [self.viewModels addObject:sectionArray];
    }
    
    
    if (self.viewModels.count == 1)
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
    self.title = [self isMine] ? @"我的主页": @"他的主页";
    
    self.leftButton.frame = CGRectMake(kSpace, 20 + kNavigationBarTop, self.leftButton.frame.size.width, self.leftButton.frame.size.height);
    [self.view addSubview:self.leftButton];
    
    self.table = [KitFactory tableView];
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarTop);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    [self.view bringSubviewToFront:self.leftButton];
    [self.view bringSubviewToFront:self.rightButton];
    
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.table.mj_footer.hidden = YES;
    
    [self.headView addSubview:self.profileView];
    self.optionView.frame = CGRectMake(0, CGRectGetMaxY(self.profileView.frame), self.view.frame.size.width, kOptionViewHeight);
    [self.headView addSubview:self.optionView];
    
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
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (viewModel.cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_ALLCOLLECTION)//美家征集 -> 查看全部
    {
        FindAssemListViewController *vc = [[FindAssemListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (viewModel.cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY || viewModel.cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE)//如果是文章或者照片
    {
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
    else if (viewModel.cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_SHOWALL)//全文
    {
        MoreLineLabelViewModel *moreTextViewModel = sectionViewModel[indexPath.row - 1];//文本viewmodel
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
            else if (tmpViewModel.cellType == PERSONPROFILEVIEWCONTROLLERCELLTYPE_SHOWALL)
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
}

#pragma mark LazyInit
- (BOOL)isMine
{
    BOOL isMySelf = NO;//是否是自己
    if (self.uid == [Login curLoginUserID])
    {
        isMySelf = YES;
    }
    return isMySelf;
}

- (NSMutableArray *)viewModels
{
    if (!_viewModels)
    {
        _viewModels = [[NSMutableArray alloc] init];
    }
    return _viewModels;
}

- (ProfileHeadView *)profileView
{
    if (!_profileView)
    {
        _profileView = [[ProfileHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeadViewHeight)];
        _profileView.delegate = self;
    }
    return _profileView;
}

- (ProfileHeadViewModel *)profileViewModel
{
    if (!_profileViewModel)
    {
        _profileViewModel = [[ProfileHeadViewModel alloc] init];
    }
    return _profileViewModel;
}

- (NSMutableArray *)discoveryDataSources
{
    if (!_discoveryDataSources)
    {
        _discoveryDataSources = [NSMutableArray array];
    }
    return _discoveryDataSources;
}


- (void)respondsToLeftButton:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightButton:(UIButton *)button
{
    
}

- (UIButton *)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [KitFactory button];
        [_leftButton setImage:[UIImage imageNamed:@"nav_icon_left_back"] forState:UIControlStateNormal];
        [_leftButton sizeToFit];
        _leftButton.frame = CGRectMake(0, 0, _leftButton.frame.size.width, _leftButton.frame.size.height);
        [_leftButton addTarget:self action:@selector(respondsToLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [KitFactory button];
        [_rightButton setImage:[UIImage imageNamed:@"other_copy"] forState:UIControlStateNormal];
        [_rightButton sizeToFit];
        _rightButton.frame = CGRectMake(0, 0, _rightButton.frame.size.width, _rightButton.frame.size.height);
        [_rightButton addTarget:self action:@selector(respondsToRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIView *)headView
{
    if (!_headView)
    {
        _headView = [KitFactory view];
        _headView.frame = CGRectMake(0, kNavigationBarTop, self.view.frame.size.width, kOptionViewHeight + kHeadViewHeight);
    }
    return _headView;
}

- (ProfileOptionView *)optionView
{
    if (!_optionView)
    {
        _optionView = [[ProfileOptionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
        _optionView.delegate = self;
    }
    return _optionView;
}

- (ProfileOptionViewModel *)optionViewModel
{
    if (!_optionViewModel)
    {
        _optionViewModel = [[ProfileOptionViewModel alloc] init];
        _optionViewModel.optionLeftImage = [UIImage imageNamed:@"icon_contentj_photo"];
        _optionViewModel.optionRightImage = [UIImage imageNamed:@"icon_contentj_Article"];
        _optionViewModel.optionLeftTitle = @"图片 0";
        _optionViewModel.optionRightTitle = @"文章 0";
    }
    return _optionViewModel;
}


- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor cellType:(PERSONPROFILEVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel
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

- (BaseViewModel *)collectionDetailViewModelWithImageUrl:(NSString *)imageUrl dataModel:(id)dataModel
{
    CollectionDetailViewModel *viewModel = [[CollectionDetailViewModel alloc] init];
    viewModel.imgUrl = imageUrl;
    viewModel.dataModel = dataModel;
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

- (BaseViewModel *)authorViewModelWithImageUrl:(NSString *)imageUrl topTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle hasRightButton:(BOOL)hasRightButton dataModel:(id)dataModel
{
    AuthorViewModel *viewModel = [[AuthorViewModel alloc] init];
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.topTitle = topTitle;
    viewModel.bottomTitle = bottomTitle;
    viewModel.type = AUTHORVIEWMODELTYPE_EDITTYPE;
    viewModel.currentCellHeight = 56;
    viewModel.cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_ADVERTISEMENTS;
    viewModel.cellClass = [AuthorCell class];
    viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    viewModel.dataModel = dataModel;
    viewModel.hasRightButton = hasRightButton;
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

- (BaseViewModel *)moreLineLabelViewModelWithText:(NSString *)text textColor:(UIColor *)textColor lineNumber:(NSInteger)lineNumber cellType:(PERSONPROFILEVIEWCONTROLLERCELLTYPE)cellType dataModel:(FindAssemarcInfo *)dataModel
{
    MoreLineLabelViewModel *viewModel = [[MoreLineLabelViewModel alloc] init];
    viewModel.text = text;
    viewModel.font = 13;
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
    if (dataModel.assemtitle.length > 0)
    {
        viewModel.topicString = [NSString stringWithFormat:@"#%@#",dataModel.assemtitle];
    }
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
    return viewModel;
}

- (BaseViewModel *)tableviewListIsEmptyViewModel
{
    TableviewListIsEmptyViewModel *viewModel = [[TableviewListIsEmptyViewModel alloc] init];
    viewModel.emptyImage = [UIImage imageNamed:@"emptyTable"];
    viewModel.cellClass = [TableviewListIsEmptyCell class];
    viewModel.currentCellHeight = self.table.frame.size.height - kOptionViewHeight - kHeadViewHeight;
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
    viewModel.cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_DISCORVERY;
    return viewModel;
}

- (BaseViewModel *)operatedIconViewModelWithFirstImage:(UIImage *)fImage firstTitle:(NSString *)fTitle secondImage:(UIImage *)sImage secondTitle:(NSString *)sTitle thirdImage:(UIImage *)tImage thirdTitle:(NSString *)tTitle dataModel:(id)dataModel cellType:(PERSONPROFILEVIEWCONTROLLERCELLTYPE)cellType
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

- (BaseViewModel *)advertisementsOptionImageViewModelWithImageUrl:(NSString *)imageUrl cellType:(PERSONPROFILEVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel
{
    AdvertisementsOptionImageViewModel *viewModel = [[AdvertisementsOptionImageViewModel alloc] init];
    viewModel.cellClass = [AdvertisementsOptionImageCell class];
    viewModel.currentCellHeight = kRKBHEIGHT(175);
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolderImage = [UIImage imageNamed:@"placeHolder"];
    viewModel.cellType = cellType;
    viewModel.dataModel = dataModel;
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
    viewModel.cellType = PERSONPROFILEVIEWCONTROLLERCELLTYPE_ARTICLE;
    viewModel.dataModel = dataModel;
    return viewModel;
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
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:13]],NSParagraphStyleAttributeName:paragraphStyle};
    height = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height + 2;
    if (line != 0)
    {
        return height > line * [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:13]].lineHeight + 2 + (kLineSpace * (line - 1)) ?  line * [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:13]].lineHeight + 2 + (kLineSpace * (line - 1)): height;
    }
    return height;
}

#pragma mark MoreCollectionCellDelegate
- (void)moreCollectionCell:(MoreCollectionCell *)cell clickCollectionViewWithViewModel:(CollectionDetailViewModel *)viewModel;
{
    FindAssemActivityInfo *info = viewModel.dataModel;
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark AuthorCellDelegate
- (void)authorCell:(AuthorCell *)cell clickRightButtonWithViewModel:(AuthorViewModel *)viewModel;
{
    __block FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (dataModel)
    {
        WEAKSELF;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf showLoadingToast];
            [[TiHouse_NetAPIManager sharedManager] request_deleteArticleAndPhotoWithCid:dataModel.assemarcid completedUsing:^(id data, NSError *error) {
                [weakSelf dismissToast];
                if (!error)
                {
                    [self setupData];
                }
            }];
            
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
        //评论
        FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:dataModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)operatedIconCell:(OperatedIconCell *)cell clickThirdIconWithViewModel:(OperatedIconViewModel *)viewModel;
{
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (dataModel.assemarctype == 1)//文章
    {
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
}- (void)clickShare:(SHARE_TYPE)tag {
    
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

#pragma mark ProfileHeadViewDelegate
- (void)profileHeadView:(ProfileHeadView *)view clickBackgroundImageViewWithViewModel:(ProfileHeadViewModel *)viewModel;
{
    if ([self isMine])
    {
        WEAKSELF
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"修改发现封面" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf hx_presentAlbumListViewControllerWithManager:[self photoManager] delegate:weakSelf];
        }];
        [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
            vc.delegate = weakSelf;
            vc.manager = [self photoManager];
            HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
            nav.supportRotation = [self photoManager].configuration.supportRotation;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
        [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
        [alert addAction:action];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)profileHeadView:(ProfileHeadView *)view clickTopImageViewWithViewModel:(ProfileHeadViewModel *)viewModel;
{
    PersonProfileDataModel *dataModel = viewModel.dataModel;
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.imagesURL = [NSArray arrayWithObjects:dataModel.urlhead,nil];
    photoBroseView.sourceImgageViews = [NSArray arrayWithObjects:view.topIcon, nil];
    photoBroseView.currentIndex = 0;
    [photoBroseView show];
}

- (void)profileHeadView:(ProfileHeadView *)view clickCenterButtonViewWithViewModel:(ProfileHeadViewModel *)viewModel;
{
    __block PersonProfileDataModel *dataModel = viewModel.dataModel;
    if ([self isMine])
    {
        MineInfoViewController *mineInforViewController = [[MineInfoViewController alloc] init];
        [self.navigationController pushViewController:mineInforViewController animated:YES];
    }
    else
    {
        [self showLoadingToast];
        if ([dataModel.isConcern boolValue])
        {
            //取消关注
            WEAKSELF
            [[TiHouse_NetAPIManager sharedManager] request_unFollowSomeBodyWithUid:dataModel.uid completedUsing:^(id data, NSError *error) {
                [weakSelf dismissToast];
                [weakSelf showToastWithText:@"取消关注成功"];
                [self setupData];
            }];
        }
        else
        {
            //去关注
            WEAKSELF
            [[TiHouse_NetAPIManager sharedManager] request_followSomeBodyWithUid:dataModel.uid completedUsing:^(id data, NSError *error) {
                [weakSelf dismissToast];
                [weakSelf showToastWithText:@"关注成功"];
                [self setupData];
            }];
        }
    }
}

- (void)profileHeadView:(ProfileHeadView *)view clickBottomLeftViewWithViewModel:(ProfileHeadViewModel *)viewModel;
{
    PersonProfileDataModel *dataModel = viewModel.dataModel;
    FollowingViewController *followingViewController = [[FollowingViewController alloc] init];
    followingViewController.uid = [dataModel.uid integerValue];
    followingViewController.navTitle = [self isMine] ? @"我关注的喵友": [NSString stringWithFormat:@"%@关注的喵友",dataModel.username];
    [self.navigationController pushViewController:followingViewController animated:YES];
}

- (void)profileHeadView:(ProfileHeadView *)view clickBottomRightViewWithViewModel:(ProfileHeadViewModel *)viewModel;
{
    PersonProfileDataModel *dataModel = viewModel.dataModel;
    FollowerViewController *followingViewController = [[FollowerViewController alloc] init];
    followingViewController.uid = [dataModel.uid integerValue];
    followingViewController.navTitle = [self isMine] ? @"关注我的喵友": [NSString stringWithFormat:@"关注%@的喵友",dataModel.username];
    [self.navigationController pushViewController:followingViewController animated:YES];
}

- (HXPhotoManager *)photoManager
{
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    manager.configuration.deleteTemporaryPhoto = NO;
    manager.configuration.lookLivePhoto = YES; 
    manager.configuration.singleSelected = YES;//是否单选
    manager.configuration.supportRotation = NO;
    manager.configuration.cameraCellShowPreview = NO;
    manager.configuration.ToCarpPresetSquare = NO;
    manager.configuration.themeColor = kRKBNAVBLACK;
    manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
        navigationBar.barTintColor = kRKBNAVBLACK;
    };
    manager.configuration.openCamera = NO;
    manager.configuration.sectionHeaderTranslucent = NO;
    manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
    manager.configuration.sectionHeaderSuspensionTitleColor = XWColorFromHex(0x999999);
    manager.configuration.statusBarStyle = UIStatusBarStyleDefault;
    manager.configuration.selectedTitleColor = kRKBNAVBLACK;
    manager.configuration.photoListBottomView = ^(HXDatePhotoBottomView *bottomView) {
    };
    manager.configuration.movableCropBox = YES;
    manager.configuration.supportRotation = NO;
    manager.configuration.movableCropBoxEditSize = YES;
    manager.configuration.movableCropBoxCustomRatio = CGPointMake(16, 9);
    manager.configuration.hiddenRotationButton = YES;
    manager.configuration.hiddenResetButton = YES;
    manager.configuration.shouldLockCrop = YES;
    
    return manager;
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original;
{
    if (photoList.count > 0)
    {
        HXPhotoModel *imageModel = photoList[0];
        [self uploadImageWithImage:imageModel.previewPhoto];
    }
}

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    cropController.delegate = self;
    cropController.cropView.cropBoxResizeEnabled = NO;
    cropController.aspectRatioPickerButtonHidden = YES;
    cropController.aspectRatioLockEnabled = YES;
    cropController.resetAspectRatioEnabled = YES;
    cropController.rotateButtonsHidden = YES;
    cropController.doneButtonTitle = @"完成";
    cropController.cancelButtonTitle = @"取消";
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset16x9;
    cropController.toolbar.resetButton.hidden = YES;
    [self.navigationController pushViewController:cropController animated:NO];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self uploadImageWithImage:image];
    
    [cropViewController.navigationController popViewControllerAnimated:YES];
}

- (void)uploadImageWithImage:(UIImage *)image
{
    [self showLoadingToast];
    WEAKSELF
    NSData *imageData = UIImageCompress(image);
    [[TiHouse_NetAPIManager sharedManager] request_uploadFilesWithData:imageData completedUsing:^(NSString *data, NSError *error) {
        if (!error)
        {
            [[TiHouse_NetAPIManager sharedManager] request_EditAssembgurlWithUrl:data completedUsing:^(NSString *dataUrl, NSError *errora){
                [weakSelf dismissToast];
                if (!errora)
                {
                    weakSelf.profileViewModel.backgroundColorImageUrl = dataUrl;
                    [weakSelf.profileView resetViewWithViewModel:weakSelf.profileViewModel];
                }
            }];
        }
        else
        {
            [weakSelf dismissToast];
        }
    }];
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

- (void)profileOptionView:(ProfileOptionView *)view clickLeftViewWithViewModel:(ProfileOptionViewModel *)viewModel;
{
    PersonProfileDataModel *dataModel = viewModel.dataModel;
    PersonDiscoveryAndArticleViewController *personDiscoveryAndArticleViewController = [[PersonDiscoveryAndArticleViewController alloc] init];
    personDiscoveryAndArticleViewController.uid = [dataModel.uid integerValue];
    personDiscoveryAndArticleViewController.navigationTitle = [self isMine] ? @"我发布的图片": [NSString stringWithFormat:@"%@发布的图片",dataModel.username];
    personDiscoveryAndArticleViewController.type = PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS_PHOTO;
    [self.navigationController pushViewController:personDiscoveryAndArticleViewController animated:YES];
}

- (void)profileOptionView:(ProfileOptionView *)view clickRightViewWithViewModel:(ProfileOptionViewModel *)viewModel;
{
    PersonProfileDataModel *dataModel = viewModel.dataModel;
    PersonDiscoveryAndArticleViewController *personDiscoveryAndArticleViewController = [[PersonDiscoveryAndArticleViewController alloc] init];
    personDiscoveryAndArticleViewController.uid = [dataModel.uid integerValue];
    personDiscoveryAndArticleViewController.navigationTitle = [self isMine] ? @"我发布的文章": [NSString stringWithFormat:@"%@发布的文章",dataModel.username];
    personDiscoveryAndArticleViewController.type = PERSONDISCOVERYANDARTICLEVIEWCONTROLLERSTATUS_ARTICLE;
    [self.navigationController pushViewController:personDiscoveryAndArticleViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
