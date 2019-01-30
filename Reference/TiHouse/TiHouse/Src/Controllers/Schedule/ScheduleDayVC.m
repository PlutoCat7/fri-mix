//
//  ScheduleDayVC.m
//  TiHouse
//  日历界面中的日历模块
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayVC.h"
#import "ScheduleDayListView.h"
#import "ScheduleDayListViewModel.h"
#import "NewScheduleVC.h"


#import "WebViewController.h"

@interface ScheduleDayVC () <ScheduleDayListViewDelegate>

@property (nonatomic, strong) ScheduleDayListView *scheduleView;
@property (nonatomic, strong) ScheduleDayListViewModel *scheduleViewModel;

@end

@implementation ScheduleDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xl_addSubviews];
    [self xl_bindViewModel];
}

- (void)xl_bindViewModel{
    
    @weakify(self);
    [self.scheduleViewModel.cellClickSubject subscribeNext:^(id x) {
        @strongify(self);
        NewScheduleVC *nsVC = [[NewScheduleVC alloc] init];
        
        nsVC.house = self.house;
        nsVC.scheduleM = x;
        
        [self.navigationController pushViewController:nsVC animated:YES];
        
    }];
    
    //去添加
    [self.scheduleViewModel.addSchedule subscribeNext:^(id x) {
        
        NewScheduleVC * newSch = [[NewScheduleVC alloc] init];
        newSch.house = self.house;
        newSch.createDate = x;
        
        [newSch setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newSch animated:YES];
    }];
}

- (void)xl_addSubviews{
    [self.view addSubview:self.scheduleView];
    
    [self updateViewConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scheduleViewModel requestScheduleList];
}

- (void)updateViewConstraints{
    
    [self.scheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarTop);
        make.width.mas_equalTo(kScreen_Width);
    }];
    
    [super updateViewConstraints];
}

- (ScheduleDayListView *)scheduleView{
    if (!_scheduleView) {
        _scheduleView = [[ScheduleDayListView alloc] initWithViewModel:self.scheduleViewModel];
        _scheduleView.delegate = self;
    }
    return _scheduleView;
}

- (ScheduleDayListViewModel *)scheduleViewModel{
    if (!_scheduleViewModel) {
        _scheduleViewModel = [[ScheduleDayListViewModel alloc] init];
        _scheduleViewModel.houseId = self.house.houseid;
        
    }
    return _scheduleViewModel;
}

- (void)scheduleDayListView:(ScheduleDayListView *)view clickSheduleWithViewModel:(ScheduleDayListModel *)dataModel;
{
    if (dataModel)
    {
        if ([dataModel isKindOfClass:[ScheduleDayListModel class]])
        {
            if (dataModel.scheduleadvertList.count > 0)
            {
                ScheduleadvertListDataModel *advDataModel = dataModel.scheduleadvertList[0];
                if (advDataModel.allurllink.length > 0)
                {
                    WebViewController *webViewController = [[WebViewController alloc] init];
                    webViewController.webSite = advDataModel.allurllink;
                    webViewController.advertid = advDataModel.scheadvertid;
                    webViewController.adverttype = advDataModel.adverttype;
                    [self.navigationController pushViewController:webViewController animated:YES];
                }
            }
        }
        
        if ([dataModel isKindOfClass:[ScheduleModel class]])
        {
            if ([[(ScheduleModel *)dataModel allurllink] length] > 0)
            {
                WebViewController *webViewController = [[WebViewController alloc] init];
                webViewController.webSite = [(ScheduleModel *)dataModel allurllink];
                webViewController.advertid = [(ScheduleModel *)dataModel scheadvertid];
                webViewController.adverttype = [(ScheduleModel *)dataModel adverttype];
                [self.navigationController pushViewController:webViewController animated:YES];
            }
        }
    }
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
