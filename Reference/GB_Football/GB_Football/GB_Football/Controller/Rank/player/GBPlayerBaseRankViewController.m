//
//  GBPlayerBaseRankViewController.m
//  GB_Football
//
//  Created by gxd on 2017/11/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPlayerBaseRankViewController.h"
#import "GBPersonDefaultCardViewController.h"
#import "GBPlayerRankCell.h"
#import "UIImageView+WebCache.h"
#import "GBBaseViewController+Empty.h"
#import "UserRequest.h"

@interface GBPlayerBaseRankViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerVIew;
    
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *valueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
    
@property (nonatomic, assign) PlayerRank rankType;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) PlayerRankRespone *playerRankInfo;
    
@end

@implementation GBPlayerBaseRankViewController

#pragma mark -
#pragma mark Memory
    
- (instancetype)initWithType:(PlayerRank)type {
    self = [super init];
    if (self) {
        _rankType = type;
    }
    
    return self;
}

- (void)dealloc{
    
}
    
#pragma mark - Life Cycle
    
- (void)viewDidLoad {
    
    [super viewDidLoad];
}
    
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.headImageView.clipsToBounds = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
    });
    self.headerVIew.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,
                                       (145.0f*2/1334)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.headerVIew];
}
    
#pragma mark - Action

- (IBAction)actionHelp:(id)sender {
    
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        
    } title:LS(@"player.rank.label.regular.tip") message:LS(@"player.rank.label.regular.content") cancelButtonName:LS(@"player.rank.label.regular.iknow") otherButtonTitle:nil style:GBALERT_STYLE_NOMAL];
}
    
#pragma mark - Delegate
    
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playerRankInfo ? self.playerRankInfo.content.count : 0;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f;
}
    
// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPlayerRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBPlayerRankCell"];
    
    PlayerRankInfo *rankInfo = self.playerRankInfo.content[indexPath.row];
    [cell initWithPlayerRankInfo:rankInfo type:self.rankType index:indexPath.row];
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerRankInfo *rankInfo = self.playerRankInfo.content[indexPath.row];
    
    GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
    vc.userId = rankInfo.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
    
#pragma mark - Private
    
-(void)localizeUI
{
    self.rankTitleLabel.text = LS(@"team.home.rank");
}
    
-(void)setupUI
{
    self.userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    [self setupTableView];
    [self setupLabel];
}
    
-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GBPlayerRankCell" bundle:nil] forCellReuseIdentifier:@"GBPlayerRankCell"];
    self.tableView.tableHeaderView = self.headerVIew;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    self.tableView.emptyDataSetDelegate = self;
}
    
-(void)setupLabel
{
    self.valueTitleLabel.text = [self valueTitleName];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.playerName.text = self.userInfo.nick;
    
}
    
- (NSString *)valueTitleName {
    
    switch (self.rankType) {
        case PlayerRank_Score:
            return LS(@"starcard.label.index");
            break;
        case PlayerRank_Speed:
            return LS(@"starcard.label.speed");
            break;
        case PlayerRank_Endur:
            return LS(@"starcard.label.endur");
            break;
        case PlayerRank_Erupt:
            return LS(@"starcard.label.erupt");
            break;
        case PlayerRank_Sprint:
            return LS(@"starcard.label.sprint");
            break;
        case PlayerRank_Distance:
            return LS(@"starcard.label.distance");
            break;
        case PlayerRank_Area:
            return LS(@"starcard.label.area");
            break;
        
        default:
            return @"";
            break;
    }
}

- (void)initPageData {
    [self showLoadingToast];
    
    @weakify(self)
    [UserRequest getPlayerChartObj:self.rankType handle:^(id result, NSError *error) {
    
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self.tableView reloadData];
            [self showToastWithText:error.domain];
        }else {
            self.playerRankInfo = result;
            self.isShowEmptyView = self.playerRankInfo.content.count==0;
            [self refreshUI];
        }
    }];
}

- (void)refreshUI {
    NSString *valueName = @"0";
    if (self.rankType == PlayerRank_Score) {
        valueName = [NSString stringWithFormat:@"%d", (int) self.playerRankInfo.head.value];
    } else {
        valueName = [NSString stringWithFormat:@"%0.1f", self.playerRankInfo.head.value < 20 ? 20 : self.playerRankInfo.head.value];
    }
    NSInteger rankIndex = self.playerRankInfo.head.rank;
    
    self.valueLabel.text = valueName;
    if (rankIndex == 0) {
        self.rankLabel.text = LS(@"team.rank.no.list");
        self.rankLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16];
    } else {
        self.rankLabel.text = [NSString stringWithFormat:@"%d", (int) rankIndex];
        self.rankLabel.font = [UIFont fontWithName:@"BEBAS" size:20];
    }
    
    [self.tableView reloadData];
}
@end
