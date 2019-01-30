//
//  ScheduleListVC.m
//  TiHouse
//  日历列表界面
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleListVC.h"
#import "ScheduleView.h"
#import "ScheduleViewModel.h"
#import "NewScheduleVC.h"
//#import "EmptyListView.h"

@interface ScheduleListVC ()

@property (nonatomic, strong) ScheduleView *scheduleView;
@property (nonatomic, strong) ScheduleViewModel *scheduleViewModel;
//@property (nonatomic, strong) EmptyListView *emptyView;


@end

@implementation ScheduleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubViews];
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
    
//    [RACObserve(self.scheduleViewModel, arrSysData) subscribeNext:^(id x) {
//        @strongify(self);
//        NSMutableArray *arr = x;
//        if (arr.count > 0) {
//            [self setupSubViews];
//            [_emptyView removeFromSuperview];
//            _emptyView = nil;
//        }else {
//            [self addEmptyView];
//            [_scheduleView removeFromSuperview];
//            _scheduleView = nil;
//        }
//
//    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scheduleViewModel.params = [_scheduleViewModel getParamWithPage:0];
    [self.scheduleViewModel.refreshDataCommand execute:nil];
}

- (void)setupSubViews{
    [self.view addSubview:self.scheduleView];
    
    [self updateViewConstraints];
}

//- (void)addEmptyView{
//    [self.view addSubview:self.emptyView];
//
//    [self updateViewConstraints];
//}

- (void)updateViewConstraints{
    
//    if (_scheduleView) {
        [self.scheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(kNavigationBarTop);
            make.width.mas_equalTo(kScreen_Width);
        }];
//    }
//
//    if (_emptyView) {
//        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.mas_equalTo(0);
//            make.top.mas_equalTo(kNavigationBarTop);
//            make.width.mas_equalTo(kScreen_Width);
//        }];
//    }
    
    [super updateViewConstraints];
}

- (ScheduleView *)scheduleView{
    if (!_scheduleView) {
        _scheduleView = [[ScheduleView alloc] initWithViewModel:self.scheduleViewModel];
    }
    return _scheduleView;
}

//- (EmptyListView *)emptyView{
//    if (!_emptyView) {
//        _emptyView = [EmptyListView sharedInstanceWithViewModel:nil];
//        WS(weakSelf);
//        _emptyView.btnClickBlock = ^{
//            NewScheduleVC *nsVC = [[NewScheduleVC alloc] init];
//
//            nsVC.house = weakSelf.house;
//            [weakSelf.navigationController pushViewController:nsVC animated:YES];
//        };
//    }
//    return _emptyView;
//}

- (ScheduleViewModel *)scheduleViewModel{
    if (!_scheduleViewModel) {
        _scheduleViewModel = [[ScheduleViewModel alloc] init];
        _scheduleViewModel.houseId = self.house.houseid;
        _scheduleViewModel.params = [_scheduleViewModel getParamWithPage:0];
    }
    return _scheduleViewModel;
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
