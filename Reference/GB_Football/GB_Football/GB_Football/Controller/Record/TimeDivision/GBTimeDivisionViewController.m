//
//  GBTimeDivisionViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTimeDivisionViewController.h"

#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"
#import "GBGameBlockView.h"
#import "TimeDivisionTableViewCell.h"
#import "TimeDivisionSectionHeaderView.h"
#import "TimeDivisionFooterView.h"
#import "GBGameDetailUserInfoView.h"

#import "TimeDivisionViewModel.h"

@interface GBTimeDivisionViewController () <
UITableViewDelegate,
UITableViewDataSource,
TimeDivisionFooterViewDelegate,
TimeDivisionTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GBGameDetailUserInfoView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *itemView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel1;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel2;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel3;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel4;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel5;

@property (weak, nonatomic) TimeDivisionFooterView *footerView;

@property (nonatomic, strong) TimeDivisionViewModel *viewModel;

@end

@implementation GBTimeDivisionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[TimeDivisionViewModel alloc] init];
    }
    return self;
}

-(void)localizeUI{
    
    self.itemLabel1.attributedText = [self attributedString:[NSString stringWithFormat:@"%@\nKCAL", LS(@"half.label.calorie")] changeString:@"KCAL"] ;
    self.itemLabel2.attributedText = [self attributedString:[NSString stringWithFormat:@"%@\nS", LS(@"section.label.sprint.times")] changeString:@"S"] ;
    self.itemLabel3.attributedText = [self attributedString:[NSString stringWithFormat:@"%@\nM", LS(@"half.label.sprint.distance")] changeString:@"M"] ;
    self.itemLabel4.attributedText = [self attributedString:[NSString stringWithFormat:@"%@\nM/S", LS(@"half.label.fastest")] changeString:@"M/S"] ;
    self.itemLabel5.attributedText = [self attributedString:[NSString stringWithFormat:@"%@\nKM", LS(@"half.label.moving")] changeString:@"KM"] ;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *headerView = self.tableView.tableHeaderView;
        headerView.height = self.headerView.height;
        self.tableView.tableHeaderView = headerView;
        
        UIView *footerView = self.tableView.tableFooterView;
        footerView.height = 60;
        self.tableView.tableFooterView = footerView;
    });
}

#pragma mark - Public

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo {
    
    self.viewModel.sectionInfoList = matchInfo.split;
    
    if (self.viewModel.sectionInfoList.count == 0) {
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
    
    //更新球员基本信息
    self.userInfoView.matchUserInfo = matchInfo.matchUserInfo;
}

#pragma mark - Getters & Setters
- (void)setShowTimeRate:(BOOL)showTimeRate {
    _showTimeRate = showTimeRate;
    
    [self.tableView reloadData];
}

#pragma mark - Private

-(void)setupUI
{

    [self.tableView registerNib:[UINib nibWithNibName:@"TimeDivisionTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeDivisionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeDivisionSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"TimeDivisionSectionHeaderView"];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    tmpView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tmpView;
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"TimeDivisionFooterView" owner:self options:nil] firstObject];
    self.footerView.frame = CGRectMake(0, 0, kUIScreen_Width, 60);
    self.footerView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
}

- (UIImage *)getViewShareImage {
    
    UITableView *scrollView =  self.tableView;
    if (!scrollView) {
        return nil;
    }
    
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    UIView *oldTableHeaderView = self.tableView.tableHeaderView;
    UIView *oldTableFooterView = self.tableView.tableFooterView;
    
    scrollView.tableHeaderView = nil;
    scrollView.tableFooterView = nil;
    scrollView.height = scrollView.contentSize.height>oldheight?scrollView.contentSize.height:oldheight-self.headerView.height;
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[self.headerView, scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.tableHeaderView = oldTableHeaderView;
    scrollView.tableFooterView = oldTableFooterView;
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    
    return shareImage;
}

- (NSAttributedString *)attributedString:(NSString *)string changeString:(NSString *)changeString{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"BEBAS" size:12.0] range:[string rangeOfString:changeString options:NSBackwardsSearch]];
    return [attributedString copy];
}

#pragma mark - Delagate 

#pragma mark TimeDivisionFooterViewDelegate

- (void)didClickFooterView {
    
    self.viewModel.isFlod = !self.viewModel.isFlod;
    if (self.viewModel.isFlod) {
        self.footerView.tipsLabel.text = LS(@"multi-section.section.data.expand");
        [self.footerView.arrowImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    }else {
        self.footerView.tipsLabel.text = LS(@"multi-section.section.data.put.away");
        [self.footerView.arrowImageView setTransform:CGAffineTransformMakeRotation(0)];
    }
    [UIView transitionWithView:self.tableView
                      duration: 0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void) {
         [self.tableView reloadData];
     } completion:nil];
}

#pragma mark TimeDivisionTableViewCellDelegate

- (void)didSelectWithIndex:(NSInteger)index cell:(TimeDivisionTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    TimeDivisionCellModel *model = self.viewModel.cellModelList[indexPath.section];
    if (model.currentStyle == index) {
        return;
    }
    
    model.currentStyle = index;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.cellModelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.isFlod?0:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeDivisionCellModel *model = self.viewModel.cellModelList[indexPath.section];
    if (model.currentStyle == 2) { //覆盖面积
        return (NSInteger)(270.f*kAppScale);
    }else {
        return (NSInteger)(235.f*kAppScale);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.0f*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeDivisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeDivisionTableViewCell"];
    cell.delegate = self;
    
    TimeDivisionCellModel *model = self.viewModel.cellModelList[indexPath.section];
    [cell refreshWithModel:model];
    cell.showTimeRate = self.showTimeRate;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MatchSectonInfo *info = self.viewModel.sectionInfoList[section];
    TimeDivisionSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TimeDivisionSectionHeaderView"];
    NSDictionary *chineseDic = @{@"0":LS(@"multi-section.section.one"),
                                 @"1":LS(@"multi-section.section.two"),
                                 @"2":LS(@"multi-section.section.three"),
                                 @"3":LS(@"multi-section.section.four"),
                                 @"4":LS(@"multi-section.section.five")};
    headerView.sectionLabel.text = chineseDic[@(section).stringValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:info.start_time];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:info.end_time];
    headerView.timeLabel.text = [NSString stringWithFormat:@"(%02td:%02td-%02td:%02td)", startDate.hour, startDate.minute, endDate.hour, endDate.minute];
    headerView.durationLabel.text = @((info.end_time-info.start_time)/60).stringValue;
    headerView.durationLabelUnitLabel.alpha = 1;
    
    headerView.consumeLabel.text = [NSString stringWithFormat:@"%.1f", info.pc];
    headerView.consumeLabel.textColor = [self.viewModel colorWithInfo:info index:0];
    
    headerView.dashTimesLabel.text = @(info.sprint_times).stringValue;
    headerView.dashTimesLabel.textColor = [self.viewModel colorWithInfo:info index:1];
    
    headerView.dashDistanceLabel.text = [NSString stringWithFormat:@"%.1f", info.sprint_distance];
    headerView.dashDistanceLabel.textColor = [self.viewModel colorWithInfo:info index:2];
    
    headerView.maxSpeedLabel.text = [NSString stringWithFormat:@"%.1f", info.max_speed];
    headerView.maxSpeedLabel.textColor = [self.viewModel colorWithInfo:info index:3];
    
    headerView.distanceLabel.text = [NSString stringWithFormat:@"%.2f", info.move_distance/1000];
    headerView.distanceLabel.textColor = [self.viewModel colorWithInfo:info index:4];
    
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    GBLog(@"scrollViewDidScroll");
    if (self.itemView.top - scrollView.contentOffset.y>=0) {
        if (scrollView.contentOffset.y >= self.headerView.height) {
            return;
        }
        self.headerView.bottom = self.headerView.height - scrollView.contentOffset.y;
    }else {
        self.headerView.bottom = self.itemView.height;
    }
}

@end
