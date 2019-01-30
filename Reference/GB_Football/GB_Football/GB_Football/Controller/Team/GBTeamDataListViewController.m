//
//  GBTeamDataListViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamDataListViewController.h"
#import "GBRecordDetailViewController.h"

#import "GBTeamDateCell.h"
#import "GBBaseViewController+Empty.h"

@interface GBTeamDataListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *rankStLbl;
@property (weak, nonatomic) IBOutlet UILabel *propertyStLbl;

@property (nonatomic, assign) GBGameRankType rankType;

@end

@implementation GBTeamDataListViewController

#pragma mark -
#pragma mark Memory

- (instancetype)initWithType:(GBGameRankType)type
{
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


#pragma mark - Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.players.count;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GBTeamDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamDateCell"];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.rankImageView.hidden = NO;
        cell.rankImageView.image = [UIImage imageNamed:@"gold"];
        cell.rankNumberLbl.hidden = YES;
    } else if (row == 1) {
        cell.rankImageView.hidden = NO;
        cell.rankImageView.image = [UIImage imageNamed:@"silver"];
        cell.rankNumberLbl.hidden = YES;
    } else if (row == 2) {
        cell.rankImageView.hidden = NO;
        cell.rankImageView.image = [UIImage imageNamed:@"copper"];
        cell.rankNumberLbl.hidden = YES;
    } else {
        cell.rankImageView.hidden = YES;
        cell.rankNumberLbl.hidden = NO;
        cell.rankNumberLbl.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];
    }
    
    GBTeamDataDetailModel *info = self.model.players[indexPath.row];
    cell.playerNameLbl.text = info.name;
    cell.unitLal.text = info.unit;
    cell.propertyLbl.text = info.valueString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.model.modelType == TeamDataModelType_Match) {
        GBTeamDataDetailModel *info = self.model.players[indexPath.row];
        
        GBRecordDetailViewController *vc = [[GBRecordDetailViewController alloc] initWithMatchId:self.model.matchId playerId:info.playerId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Private
- (void)localizeUI {
    
    self.rankStLbl.text = LS(@"team.data.label.rank");
}

-(void)setupUI {
    
    [self setupTableView];
}

-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamDateCell" bundle:nil] forCellReuseIdentifier:@"GBTeamDateCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)initPageData {
}


#pragma mark - Setter and Getter

- (void)setModel:(GBTeamDataListModel *)model {
    
    _model = model;
    self.propertyStLbl.text = model.desc;
    [self.tableView reloadData];
}

@end
