//
//  CollectionViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCloudViewController.h"
#import "CollectionIdeaViewController.h"
#import "ColorCardFavorViewController.h"
#import "SAFavorViewController.h"
#import "FindArticleFavorViewController.h"
#import "PosterFavorViewController.h"
#import "CollectionTableViewCell.h"
#import "Login.h"

#import "BaseViewModel.h"
#import "BaseTableViewCell.h"
#import "BaseCellLineViewModel.h"

#import "NoneContentCell.h"
#import "NoneContentViewModel.h"

#import "OneTitleCell.h"
#import "OneTitleViewModel.h"

#import "LeftRightTitleArrowCell.h"
#import "LeftRightTitleArrowViewModel.h"

#import "CollectionNumberListDataModel.h"

#import "MyCollectedArticleViewController.h"

#import "AllPicturesViewController.h"

typedef NS_ENUM(NSInteger , COLLECTIONVIEWCONTROLLERCELLTYPE) {
    COLLECTIONVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    COLLECTIONVIEWCONTROLLERCELLTYPE_ICLOUD,//云记录
    COLLECTIONVIEWCONTROLLERCELLTYPE_ALBUM,//我的灵感册
    COLLECTIONVIEWCONTROLLERCELLTYPE_MYCOLLECTION,//我收藏的文章
    COLLECTIONVIEWCONTROLLERCELLTYPE_XIAOBAO,//有数小宝
    COLLECTIONVIEWCONTROLLERCELLTYPE_SIZE,//尺寸宝典
    COLLECTIONVIEWCONTROLLERCELLTYPE_COLORS,//软装色卡
    COLLECTIONVIEWCONTROLLERCELLTYPE_FURNITURE//家具风水
};

@interface CollectionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;

@end

@implementation CollectionViewController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)setupData
{
    [self.viewModels removeAllObjects];
    
    [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor clearColor]]];
    
    if (1)//如果有有数
    {
        [self.viewModels addObject:[self oneTitleViewModelWithTitle:@"有数"]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"云记录" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_ICLOUD hasBottomLine:NO]];
    }
  
    if (1)//如果有发现
    {
        [self.viewModels addObject:[self oneTitleViewModelWithTitle:@"发现"]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"我收藏的图片" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_ALBUM hasBottomLine:YES]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"我收藏的文章" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_MYCOLLECTION hasBottomLine:NO]];
    }
    
    if (1)//如果有知识
    {
        [self.viewModels addObject:[self oneTitleViewModelWithTitle:@"知识"]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"有数小报" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_XIAOBAO hasBottomLine:YES]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"尺寸宝典" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_SIZE hasBottomLine:YES]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"软装色卡" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_COLORS hasBottomLine:YES]];
        [self.viewModels addObject:[self leftRightTitleArrowViewModelWithLeftTitle:@"家居风水" rightTitle:@"0条记录" cellType:COLLECTIONVIEWCONTROLLERCELLTYPE_FURNITURE hasBottomLine:NO]];
    }
    [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor clearColor]]];
    
    [[TiHouse_NetAPIManager sharedManager] request_unreadMessageNumberCompletedUsing:^(NSArray *data, NSError *error) {
        if (!error)
        {
            for (BaseViewModel *tmpViewModel in self.viewModels)
            {
                NSString *option = nil;
                CollectionNumberListDataModel *dataModel = nil;
                if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_ICLOUD)
                {
                    if (data.count >= 1)
                    {
                        dataModel = data[0];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_ALBUM)
                {
                    if (data.count >= 2)
                    {
                        dataModel = data[1];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_MYCOLLECTION)
                {
                    if (data.count >= 3)
                    {
                        dataModel = data[2];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_XIAOBAO)
                {
                    if (data.count >= 4)
                    {
                        dataModel = data[3];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_SIZE)
                {
                    if (data.count >= 5)
                    {
                        dataModel = data[4];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_COLORS)
                {
                    if (data.count >= 6)
                    {
                        dataModel = data[5];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
                else if (tmpViewModel.cellType == COLLECTIONVIEWCONTROLLERCELLTYPE_FURNITURE)
                {
                    if (data.count >= 7)
                    {
                        dataModel = data[6];
                        option = [NSString stringWithFormat:@"%@条记录",dataModel.count];
                        [(LeftRightTitleArrowViewModel *)tmpViewModel setRightTitle:option];
                    }
                }
            }
            [self.table reloadData];
        }
    }];
}

- (void)setupUIInterface
{
    self.title = @"我的收藏";
    
    self.table = [KitFactory tableView];
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[LeftRightTitleArrowCell class] forCellReuseIdentifier:NSStringFromClass([LeftRightTitleArrowCell class])];
    [self.table registerClass:[NoneContentCell class] forCellReuseIdentifier:NSStringFromClass([NoneContentCell class])];
    [self.table registerClass:[OneTitleCell class] forCellReuseIdentifier:NSStringFromClass([OneTitleCell class])];
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
    BaseViewModel *viewModel    = self.viewModels[indexPath.row];
    if (viewModel.currentCellHeight == 0)
    {
        viewModel.currentCellHeight = [viewModel.cellClass currentCellHeightWithViewModel:viewModel];
    }
    return viewModel.currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel    = self.viewModels[indexPath.row];
    switch (viewModel.cellType)
    {
        case COLLECTIONVIEWCONTROLLERCELLTYPE_ICLOUD:
        {
            //云记录
            CollectionCloudViewController *collCloudVC = [CollectionCloudViewController new];
            [self.navigationController pushViewController:collCloudVC animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_ALBUM:
        {
            //我收藏的图片
            AllPicturesViewController *allPictureController = [[AllPicturesViewController alloc] init];
            [self.navigationController pushViewController:allPictureController animated:YES];
//            CollectionIdeaViewController *collectionIdeaViewController = [[CollectionIdeaViewController alloc] init];
//            [self.navigationController pushViewController:collectionIdeaViewController animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_MYCOLLECTION:
        {
           //我收藏的文章
            MyCollectedArticleViewController *myCollectedArticleViewController = [[MyCollectedArticleViewController alloc] init];
            [self.navigationController pushViewController:myCollectedArticleViewController animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_XIAOBAO:
        {
            //有数小宝
            PosterFavorViewController *pofVC = [PosterFavorViewController new];
            [self.navigationController pushViewController:pofVC animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_SIZE:
        {
            //尺寸宝典
            SAFavorViewController *safVC = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Size];
            [self.navigationController pushViewController:safVC animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_COLORS:
        {
            //软装色卡
            ColorCardFavorViewController *ccfVC = [ColorCardFavorViewController new];
            [self.navigationController pushViewController:ccfVC animated:YES];
        }
            break;
        case COLLECTIONVIEWCONTROLLERCELLTYPE_FURNITURE:
        {
            //家具风水
            SAFavorViewController *safVC = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Arrange];
            [self.navigationController pushViewController:safVC animated:YES];
        }
            break;
        default:
            break;
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

- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor
{
    NoneContentViewModel *viewModel = [[NoneContentViewModel alloc] init];
    viewModel.cellBackgroundColor   = backgroundColor;
    viewModel.cellClass             = [NoneContentCell class];
    viewModel.currentCellHeight     = height;
    if (hasBottomLine)
    {
        viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return viewModel;
}

- (BaseViewModel *)oneTitleViewModelWithTitle:(NSString *)title
{
    OneTitleViewModel *oneTitleViewModel = [[OneTitleViewModel alloc] init];
    oneTitleViewModel.title = title;
    oneTitleViewModel.cellClass = [OneTitleCell class];
    oneTitleViewModel.currentCellHeight = 40;
    return oneTitleViewModel;
}

- (BaseViewModel *)leftRightTitleArrowViewModelWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle cellType:(COLLECTIONVIEWCONTROLLERCELLTYPE)cellType hasBottomLine:(BOOL)bottomLine
{
    LeftRightTitleArrowViewModel *viewModel = [[LeftRightTitleArrowViewModel alloc] init];
    viewModel.cellType = cellType;
    viewModel.cellClass = [LeftRightTitleArrowCell class];
    viewModel.leftTitle = leftTitle;
    viewModel.rightTitle = rightTitle;
    viewModel.arrowImage = [UIImage imageNamed:@"icon_content_right_go"];
    viewModel.currentCellHeight = 56;
    if (bottomLine)
    {
        viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    }
    return viewModel;
}

//
//@interface CollectionViewController () <UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSArray *titles;
//@property (nonatomic, strong) NSArray *counts;
//@end
//
//@implementation CollectionViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"我的收藏";
//    [self tableView];
//    [self getCollections];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return (section == 0) ? 1: (section == 1 ? 2 : 4);
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"cellId";
//    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    cell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
//    cell.countLabel.text = [NSString stringWithFormat:@"%@条记录", self.counts[indexPath.section][indexPath.row][@"count"] ?: @"0"];
//    cell.topLineStyle = CellLineStyleFill;
//    cell.bottomLineStyle = CellLineStyleFill;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return kRKBHEIGHT(49);
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        CollectionCloudViewController *collCloudVC = [CollectionCloudViewController new];
//        [self.navigationController pushViewController:collCloudVC animated:YES];
//    }
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        CollectionIdeaViewController *collIdeaVC = [CollectionIdeaViewController new];
//        [self.navigationController pushViewController:collIdeaVC animated:YES];
//    }
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        FindArticleFavorViewController *articleVC = [FindArticleFavorViewController new];
//        [self.navigationController pushViewController:articleVC animated:YES];
//    }
//    if (indexPath.section == 2 && indexPath.row == 0) {
//        PosterFavorViewController *pofVC = [PosterFavorViewController new];
//        [self.navigationController pushViewController:pofVC animated:YES];
//    }
//    if (indexPath.section == 2 && indexPath.row == 1) {
//        SAFavorViewController *safVC = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Size];
//        [self.navigationController pushViewController:safVC animated:YES];
//    }
//    if (indexPath.section == 2 && indexPath.row == 2) {
//        ColorCardFavorViewController *ccfVC = [ColorCardFavorViewController new];
//        [self.navigationController pushViewController:ccfVC animated:YES];
//    }
//    if (indexPath.section == 2 && indexPath.row == 3) {
//        SAFavorViewController *safVC = [[SAFavorViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Arrange];
//        [self.navigationController pushViewController:safVC animated:YES];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 30, tableView.frame.size.width, 40)];
//    headerView.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 40)];
//    label.text = (section == 0) ? @"有数" : (section == 1 ? @"发现" : @"知识");
//    label.textColor = [UIColor colorWithHexString:@"9999999"];
//    label.font = [UIFont systemFontOfSize:16];
//    [headerView addSubview:label];
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
//
//#pragma mark - getters and setters
//
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.scrollEnabled = NO;
//        _tableView.backgroundView = [UIView new];
//        _tableView  .backgroundColor = [UIColor clearColor];
//        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
//        }];
//    }
//    return _tableView;
//}
//
//- (NSArray *)titles {
//    return @[
//                @[@"云记录"],
//                @[@"我的灵感册",@"我收藏的文章"],
//                @[@"有数小报", @"尺寸宝典", @"软装色卡", @"家具风水"]
//            ];
//}
//
//- (void)getCollections {
//    User *user = [Login curLoginUser];
//    WEAKSELF
//    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/collectionmine/listByUid" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
//        if ([data[@"is"] intValue]) {
//            _counts = @[
//                        @[data[@"data"][0]],
//                        @[data[@"data"][1], data[@"data"][2]],
//                        @[data[@"data"][3], data[@"data"][4], data[@"data"][5], data[@"data"][6]]
//                        ];
//            [weakSelf.tableView reloadData];
//        } else {
//            _counts = @[
//                        @[@"0"],
//                        @[@"0", @"0"],
//                        @[@"0", @"0", @"0", @"0"]
//                        ];
//            NSLog(@"%@", error);
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
