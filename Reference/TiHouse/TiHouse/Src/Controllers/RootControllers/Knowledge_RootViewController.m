//
//  Knowledge_RootViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "Knowledge_RootViewController.h"
#import "PosterViewController.h"
#import "SizeViewController.h"
#import "ArrangeViewController.h"
#import "ColorCardViewController.h"
#import "AllSearchViewController.h"

#import "KTextTableViewCell.h"
#import "KnowledgeHeaderView.h"

#import "KnowledgeRequest.h"
#import "UnReadManager.h"

#import "BaseViewModel.h"
#import "BaseTableViewCell.h"
#import "BaseCellLineViewModel.h"

#import "OptionDetailCell.h"
#import "OptionDetailViewModel.h"

#import "NoneContentCell.h"
#import "NoneContentViewModel.h"

#import "AdvertisementsOptionTitleCell.h"
#import "AdvertisementsOptionTitleViewModel.h"

#import "AdvertisementsOptionImageCell.h"
#import "AdvertisementsOptionImageViewModel.h"

#import "CommonDataCenter.h"

#import "KnowledgeAdvertisementsDataModel.h"

#import "WebViewController.h"

NSString *const kPosterCountKey = @"kPosterCountKey";
NSString *const kPosterTimeKey = @"kPosterTimeKey";

typedef NS_ENUM(NSInteger , KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE) {
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_YOUSHUXIAOBAO,//有数小宝
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_SIZE,//尺寸宝典
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADDRESS,//软装色卡
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_FENGSHUI,//家居风水
    KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT//广告
};


@interface Knowledge_RootViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) KnowledgeHeaderView *tableHeaderView;

@end

@implementation Knowledge_RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUIInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, kRKBHEIGHT(50));
    self.table.tableHeaderView = self.tableHeaderView;
    
    [self.table reloadData];
}

- (void)setupData
{
    [self.viewModels removeAllObjects];
    
    if (1)//如果有有数小报
    {
        [self.viewModels addObject:[self emptyModelWithHeight:1 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT]];
        [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"know1" optionText:@"有数小报" rightBadgeValue:@"0" cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_YOUSHUXIAOBAO hasTopLine:YES topEdge:UIEdgeInsetsMake(0, 0, 0, 0) bottomEdge:UIEdgeInsetsMake(0, 0, 0, 0)]];
        [self.viewModels addObject:[self emptyModelWithHeight:15 hasBottomLine:YES backgroundColor:[UIColor clearColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT]];
    }
    
    if (1)//如果有尺寸宝典、软装色卡 家居风水
    {
        [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"know2" optionText:@"尺寸宝典" rightBadgeValue:@"0" cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_SIZE hasTopLine:NO topEdge:UIEdgeInsetsMake(0, 0, 0, 0) bottomEdge:UIEdgeInsetsMake(0, 10, 0, 10)]];
        [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"know3" optionText:@"软装色卡" rightBadgeValue:@"0" cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADDRESS hasTopLine:NO topEdge:UIEdgeInsetsMake(0, 0, 0, 0) bottomEdge:UIEdgeInsetsMake(0, 10, 0, 10)]];
        [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"know4" optionText:@"家居风水" rightBadgeValue:@"0" cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_FENGSHUI hasTopLine:NO topEdge:UIEdgeInsetsMake(0, 0, 0, 0) bottomEdge:UIEdgeInsetsMake(0, 0, 0, 0)]];
        [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT]];
    }
    
    if ([[CommonDataCenter shareCommonDataCenter] knowledgeAdvertisementsModel] && [[CommonDataCenter shareCommonDataCenter] hasKnowledgeAdvertisements])//如果有广告
    {
        KnowledgeAdvertisementsDataModel *dataModel = [[CommonDataCenter shareCommonDataCenter] knowledgeAdvertisementsModel];
        if (dataModel.urlpicindex.length > 0)
        {
            [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT]];
            [self.viewModels addObject:[self advertisementsOptionTitleViewModelWithTitle:dataModel.knowadvertname]];
            [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT]];
            [self.viewModels addObject:[self advertisementsOptionImageViewModelWithImageUrl:dataModel.urlpicindex]];
            [self.viewModels addObject:[self emptyModelWithHeight:16 hasBottomLine:NO backgroundColor:[UIColor whiteColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT]];
        }
    }
    
    [self.viewModels addObject:[self emptyModelWithHeight:28 hasBottomLine:NO backgroundColor:[UIColor clearColor] cellType:KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT]];
    
    [self.table reloadData];
    
    NSInteger lastTime = [[NSUserDefaults standardUserDefaults] integerForKey:kPosterTimeKey];

    WEAKSELF
    [KnowledgeRequest getNewPosterCount:lastTime handler:^(id result, NSError *error) {
        if (!error) {
            NSNumber *count = result;
            [[NSUserDefaults standardUserDefaults] setInteger:[count integerValue] forKey:kPosterCountKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSInteger index = 0;
            for (int i = 0 ; i < self.viewModels.count; i++)
            {
                BaseViewModel *viewModel = weakSelf.viewModels[i];
                if (viewModel.cellType == KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_YOUSHUXIAOBAO)
                {
                    index = i;
                    break;
                }
            }

            [self.table reloadData];
        }
    }];
    
    if (![[CommonDataCenter shareCommonDataCenter] knowledgeAdvertisementsModel])//如果有广告
    {
        WEAKSELF
        
        [[TiHouse_NetAPIManager sharedManager] request_knowLedgeAdvertisementsWithPath:@"api/outer/advert/getKnowAdvert" Params:nil Block:^(KnowledgeAdvertisementsDataModel *data, NSError *error) {
            if (!error)
            {
                [[CommonDataCenter shareCommonDataCenter] setHasKnowledgeAdvertisements:YES];
                [[CommonDataCenter shareCommonDataCenter] setKnowledgeAdvertisementsModel:data];
                [weakSelf setupData];
            }
        }];
    }
    
    [KnowledgeRequest getNewPosterCount:time(NULL) handler:^(NSNumber *result, NSError *error) {
        NSInteger index = 0;
        for (int i = 0 ; i < self.viewModels.count; i++)
        {
            BaseViewModel *tmpViewModel = self.viewModels[i];
            if (tmpViewModel.cellType == KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_YOUSHUXIAOBAO)
            {
                [(OptionDetailViewModel *)tmpViewModel setRightOptionText:[NSString stringWithFormat:@"%ld",[result integerValue]]];
                index = i;
                break;
            }
        }
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}


- (void)setupUIInterface
{
    self.title = @"知识";
    
    self.table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    self.table.separatorInset = UIEdgeInsetsZero;
    self.table.tableHeaderView = self.tableHeaderView;

    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, kTABBARH, 0));
    }];
    
    [self.table registerClass:[OptionDetailCell class] forCellReuseIdentifier:NSStringFromClass([OptionDetailCell class])];
    [self.table registerClass:[NoneContentCell class] forCellReuseIdentifier:NSStringFromClass([NoneContentCell class])];
    [self.table registerClass:[AdvertisementsOptionTitleCell class] forCellReuseIdentifier:NSStringFromClass([AdvertisementsOptionTitleCell class])];
    [self.table registerClass:[AdvertisementsOptionImageCell class] forCellReuseIdentifier:NSStringFromClass([AdvertisementsOptionImageCell class])];
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
        case KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_YOUSHUXIAOBAO:
        {
            [[NSUserDefaults standardUserDefaults] setInteger:([[NSDate date] timeIntervalSince1970] * 1000) forKey:kPosterTimeKey];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPosterCountKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            PosterViewController *posterVC = [PosterViewController new];
            [self.navigationController pushViewController:posterVC animated:YES];
            
            //更新未读数
            [self upUnread];
        }
            break;
        case KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_SIZE:
        {
            SizeViewController *sizeVC = [SizeViewController new];
            [self.navigationController pushViewController:sizeVC animated:YES];
        }
            break;
        case KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADDRESS:
        {
            ColorCardViewController *colorCardVC = [ColorCardViewController new];
            [self.navigationController pushViewController:colorCardVC animated:YES];
        }
            break;
        case KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_FENGSHUI:
        {
            ArrangeViewController *arrangeVC = [ArrangeViewController new];
            [self.navigationController pushViewController:arrangeVC animated:YES];
        }
            break;
        case KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT:
        {
            if ([[[CommonDataCenter shareCommonDataCenter] knowledgeAdvertisementsModel] allurllink].length > 0)
            {
                KnowledgeAdvertisementsDataModel *dataModel = [[CommonDataCenter shareCommonDataCenter] knowledgeAdvertisementsModel];
                WebViewController *webViewController = [[WebViewController alloc] init];
                webViewController.advertid = dataModel.knowadvertid;
                webViewController.adverttype = dataModel.adverttype;
                webViewController.webSite = dataModel.allurllink;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
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

- (KnowledgeHeaderView *)tableHeaderView {

    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"KnowledgeHeaderView" owner:self options:nil].firstObject;
        WEAKSELF
        _tableHeaderView.clickBlock = ^ {
            [weakSelf.navigationController pushViewController:[AllSearchViewController new] animated:YES];
        };
    }
    return _tableHeaderView;
}

- (BaseViewModel *)optionDetailViewModelWithIconName:(NSString *)iconName optionText:(NSString *)optionText rightBadgeValue:(NSString *)badgeValue cellType:(KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE)cellType hasTopLine:(BOOL)hasTopLine topEdge:(UIEdgeInsets)topEdge bottomEdge:(UIEdgeInsets)bottomEdge
{
    OptionDetailViewModel *viewModel = [[OptionDetailViewModel alloc] init];
    viewModel.leftIcon = [UIImage imageNamed:iconName];
    viewModel.optionText = optionText;
    viewModel.rightOptionText = badgeValue;
    viewModel.cellClass = [OptionDetailCell class];
    viewModel.currentCellHeight = kRKBHEIGHT(55);
    if (hasTopLine)
    {
        viewModel.cellLineViewModel.topLineEdgeInsets = topEdge;
    }
    viewModel.cellLineViewModel.bottomLineEdgeInsets = bottomEdge;
    viewModel.cellType = cellType;
    return viewModel;
}

- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor cellType:(KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE)cellType
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
    return viewModel;
}

- (BaseViewModel *)advertisementsOptionTitleViewModelWithTitle:(NSString *)title
{
    AdvertisementsOptionTitleViewModel *viewModel = [[AdvertisementsOptionTitleViewModel alloc] init];
    viewModel.cellClass = [AdvertisementsOptionTitleCell class];
    viewModel.title = title;
    viewModel.rightTitle = @"广告";
    viewModel.currentCellHeight = 18;
    viewModel.cellType = KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT;
    return viewModel;
}

- (BaseViewModel *)advertisementsOptionImageViewModelWithImageUrl:(NSString *)imageUrl
{
    AdvertisementsOptionImageViewModel *viewModel = [[AdvertisementsOptionImageViewModel alloc] init];
    viewModel.cellClass = [AdvertisementsOptionImageCell class];
    viewModel.currentCellHeight = kRKBHEIGHT(175);
    viewModel.imageUrl = imageUrl;
    viewModel.placeHolderImage = [UIImage imageNamed:@"placeHolder"];
    viewModel.cellType = KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT;
    return viewModel;
}

-(void)upUnread{
     UnReadManager * unread = [UnReadManager shareManager];
    unread.know_update_count = @(0);
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user//editUsernumunreadknowToZero" withParams:nil withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark AdvertisementsOptionTitleCellDelegate
- (void)advertisementsOptionTitleCell:(AdvertisementsOptionTitleCell *)cell clickRightViewWithViewModel:(AdvertisementsOptionTitleViewModel *)viewModel;
{
    WEAKSELF;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我不感兴趣" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *tmpViewModels = [weakSelf.viewModels copy];
        for (BaseViewModel *tmpViewModel in tmpViewModels)
        {
            if (tmpViewModel.cellType == KNOWLEDGE_ROOTVIEWCONTROLLERCELLTYPE_ADVERTISEMENT)
            {
                [weakSelf.viewModels removeObject:tmpViewModel];
            }
        }
        
        [weakSelf.table reloadData];
        [[CommonDataCenter shareCommonDataCenter] setHasKnowledgeAdvertisements:NO];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
  
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [alert addAction:action];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
