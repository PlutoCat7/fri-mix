//
//  MyCollectedArticleViewController.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MyCollectedArticleViewController.h"

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

#import "TableviewListIsEmptyViewModel.h"
#import "TableviewListIsEmptyCell.h"

#import "PersonProfileViewController.h"

#import "Login.h"

#import "CollectedArticleBottomCell.h"
#import "CollectedArticleBottomViewModel.h"

#define kMaxLine 4
#define kShareViewIndexSectionKey @"kShareViewIndexSectionKey"
#define kLineSpace 10
#define kMaxCount 20

typedef NS_ENUM(NSInteger , MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE) {
    MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE,//发现用户发的文章
};


@interface MyCollectedArticleViewController () <UITableViewDelegate,UITableViewDataSource,SwitchOptionsViewDelegate,MoreCollectionCellDelegate,SDPhotoBrowserDelegate,GBSharePanDelegate>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) NSMutableArray *discoveryDataSources;//发现数据

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;

@end

@implementation MyCollectedArticleViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupData];
}

- (void)setupData
{
    [self reloadData];
}

- (void)reloadData
{
    WEAKSELF
    //我收藏的文章
    [[TiHouse_NetAPIManager sharedManager] request_collectedArticleWithIndex:0 completedUsing:^(NSArray *data, NSError *error) {
        [weakSelf.table.mj_header endRefreshing];
        if (!error)
        {
            [weakSelf.discoveryDataSources removeAllObjects];
            [weakSelf.discoveryDataSources addObjectsFromArray:data];
            [weakSelf resetViewModelWithShouldRemoveAll:YES dataModel:data];

            weakSelf.table.mj_footer.hidden = data.count < 20;
        }
    }];
}

- (void)loadMoreData
{
    WEAKSELF
    //我收藏的文章
    [[TiHouse_NetAPIManager sharedManager] request_collectedArticleWithIndex:self.discoveryDataSources.count completedUsing:^(NSArray *data, NSError *error) {
        [weakSelf.table.mj_header endRefreshing];
        if (!error)
        {
            [weakSelf.discoveryDataSources addObjectsFromArray:data];
            [weakSelf resetViewModelWithShouldRemoveAll:NO dataModel:data];
            weakSelf.table.mj_footer.hidden = data.count < 20;
        }
    }];
}

- (void)resetViewModelWithShouldRemoveAll:(BOOL)shouldRemoveAllFirst dataModel:(NSArray *)dataModelArray
{
    if (shouldRemoveAllFirst)
    {
        [self.viewModels removeAllObjects];
    }

    if (dataModelArray && dataModelArray.count > 0)//如果有文章
    {
        [self.viewModels addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_DEFAULT dataModel:nil]];

        for (int i = 0; i < dataModelArray.count; i++)
        {
            FindAssemarcInfo *dataModel = dataModelArray[i];
            MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE cellType = MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_DEFAULT;//是否是文章 还是图片类型
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
                cellType = MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE;
                operatedFirstImage = dataModel.assemarciszan ? [UIImage imageNamed:@"find_root_has_like"] : [UIImage imageNamed:@"find_root_like"];
                operatedFirstTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumzan];
                operatedSecondImage = dataModel.assemarciscoll ? [UIImage imageNamed:@"find_root_has_collection"] : [UIImage imageNamed:@"find_root_collection"];
                operatedSecondTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcoll];
                operatedThirdImage = [UIImage imageNamed:@"find_root_comment"];
                operatedThirdTitle = [NSString stringWithFormat:@"%ld",dataModel.assemarcnumcomm];
            }
    
            float maxTextHeight = [self textHeightWithText:moreLineText numberOfLine:0];
            float textHeight = [self textHeightWithText:moreLineText numberOfLine:4];
            if (maxTextHeight > textHeight)
            {
                hasShowAllButton = YES;
            }
            
            
            if (cellType == MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE)//如果是文章
            {
                [self.viewModels addObject:[self advertisementsOptionImageViewModelWithImageUrl:dataModel.urlindex cellType:MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE dataModel:dataModel]];
                [self.viewModels addObject:[self morelLineLabelWithBackgroundViewModelWithText:dataModel.assemarctitle font:14 textColor:RGB(0, 0, 0) dataModel:dataModel]];
                [self.viewModels addObject:[self collectedArticleBottomViewModelWithLeftImageUrl:dataModel.urlhead name:dataModel.username time:dataModel.createtimeStr dataModel:dataModel]];
            }
            
            [self.viewModels addObject:[self emptyModelWithHeight:15 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE dataModel:dataModel]];
        }
    }
    
    
    if (self.viewModels.count == 0)
    {
        //填充空白数据
        [self.viewModels addObject:[self tableviewListIsEmptyViewModel]];
    }
    
    [self.table reloadData];
}


- (void)setupUIInterface
{
    self.title = @"我收藏的文章";
    
    self.table = [KitFactory tableView];
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
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
    [self.table registerClass:[CollectedArticleBottomCell class] forCellReuseIdentifier:NSStringFromClass([CollectedArticleBottomCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel = self.viewModels[indexPath.row];
    BaseTableViewCell *cell  = [self.table dequeueReusableCellWithIdentifier:viewModel.cellIndentifier];
    cell.delegate = self;
    [cell resetCellWithViewModel:viewModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel = self.viewModels[indexPath.row];
    if (viewModel.currentCellHeight == 0)
    {
        viewModel.currentCellHeight = [viewModel.cellClass currentCellHeightWithViewModel:viewModel];
    }
    return viewModel.currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel = self.viewModels[indexPath.row];
    FindAssemarcInfo *dataModel = viewModel.dataModel;
    if (viewModel.cellType == MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE)
    {
        FindArticleDetailViewController *findArticleDetailViewController = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:dataModel];
        [self.navigationController pushViewController:findArticleDetailViewController animated:YES];
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

- (NSMutableArray *)discoveryDataSources
{
    if (!_discoveryDataSources)
    {
        _discoveryDataSources = [NSMutableArray array];
    }
    return _discoveryDataSources;
}

- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor cellType:(MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel
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

- (BaseViewModel *)advertisementsOptionImageViewModelWithImageUrl:(NSString *)imageUrl cellType:(MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE)cellType dataModel:(id)dataModel
{
    AdvertisementsOptionImageViewModel *viewModel = [[AdvertisementsOptionImageViewModel alloc] init];
    viewModel.cellClass = [AdvertisementsOptionImageCell class];
    viewModel.currentCellHeight = kRKBHEIGHT(175);
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolderImage = [UIImage imageNamed:@"placeHolder"];
    viewModel.cellType = cellType;
    viewModel.cellBackgroundColor = [UIColor clearColor];
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

- (BaseViewModel *)collectedArticleBottomViewModelWithLeftImageUrl:(NSString *)imgUrl name:(NSString *)name time:(NSString *)time dataModel:(id)dataModel
{
    CollectedArticleBottomViewModel *viewModel = [[CollectedArticleBottomViewModel alloc] init];
    viewModel.cellClass = [CollectedArticleBottomCell class];
    viewModel.currentCellHeight = 40;
    viewModel.leftImageUrl = imgUrl;
    viewModel.leftPlaceHolder = [UIImage imageNamed:@"placeHolder"];
    viewModel.name = name;
    viewModel.time = time;
    viewModel.dataModel = dataModel;
    viewModel.rightButton = [UIImage imageNamed:@"find_root_has_collection"];
    viewModel.cellType = MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE;
    return viewModel;
}

- (BaseViewModel *)morelLineLabelWithBackgroundViewModelWithText:(NSString *)text font:(float)font textColor:(UIColor *)textColor dataModel:(id)dataModel
{
    MorelLineLabelWithBackgroundViewModel *viewModel = [[MorelLineLabelWithBackgroundViewModel alloc] init];
    viewModel.text = text;
    viewModel.font = font;
    viewModel.textColor = textColor;
    viewModel.lineNumber = 0;
    viewModel.cellBackgroundColor = [UIColor clearColor];
    viewModel.backgroundViewColor = [UIColor whiteColor];
    CGSize titleTextSize = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - viewModel.leftSpace - viewModel.rightSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:font]]} context:nil].size;
    viewModel.currentCellHeight = titleTextSize.height + 15 * 2;
    viewModel.cellClass = [MorelLineLabelWithBackgroundCell class];
    viewModel.moreLineLabelHeight = titleTextSize.height;
    viewModel.cellType = MYCOLLECTEDARTICLEVIEWCONTROLLERCELLTYPE_ARTICLE;
    viewModel.dataModel = dataModel;
    viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
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

#pragma mark CollectedArticleBottomCellDelegate
- (void)collectedArticleBottomCell:(CollectedArticleBottomCell *)cell clickRightButtonWithViewModel:(CollectedArticleBottomViewModel *)viewModel;
{
    //取消收藏
    WEAKSELF
    __block FindAssemarcInfo *tmpDataModel = viewModel.dataModel;
    [AssemarcRequest removeAssemarcFavor:tmpDataModel.assemarcid handler:^(GBResponseInfo *model, NSError *error) {
        [weakSelf dismissToast];
        if (model.is)
        {
            [self showToastWithText:@"取消收藏成功"];
            NSArray *tmpViewModels = [self.viewModels copy];
            for (BaseViewModel *tmpViewModel in tmpViewModels)
            {
                if (tmpViewModel.dataModel == tmpDataModel)
                {
                    [self.viewModels removeObject:tmpViewModel];
                }
            }
            [self.table reloadData];
        }
    }];
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
