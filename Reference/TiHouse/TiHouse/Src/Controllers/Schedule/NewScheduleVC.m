//
//  NewScheduleVC.m
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewScheduleVC.h"
#import "NewScheduleView.h"
#import "NewScheduleModel.h"
#import "RemindPeopleVC.h"
#import "RemindListVC.h"

@interface NewScheduleVC ()
@property (strong, nonatomic) NewScheduleView * newScheduleView;
@property (strong, nonatomic) NewScheduleModel * scheduleModel;

@end

@implementation NewScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.scheduleM) {
        self.title = @"编辑日程";
    } else {
        self.title = @"新建日程";
    }
    self.view.backgroundColor = XWColorFromHex(0xECECEC);
    
    [self addSubviews];
    [self bindViewModel];
}

-(void)addSubviews {
    [self.view addSubview:self.newScheduleView];
    
    if (self.scheduleM) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"s_delect"] style:UIBarButtonItemStylePlain target:self action:@selector(delAction)];
    }
}

#pragma mark - 删除事件
-(void)delAction {
    WEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确定要将事项从日程中删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 2.2  创建Cancel Login按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.scheduleModel requestDeleteSchedule:^(id data) {
            //回调刷新
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock();
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    // 2.3 添加按钮
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    // 3.显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - model action
-(void)bindViewModel {
    
    //提醒谁看
    WEAKSELF;
    [self.scheduleModel.remindPeopleSubject subscribeNext:^(id x) {
        [weakSelf pushToRemindPeopleController:x];
    }];
    
    //提醒什么时间看
    [self.scheduleModel.remindTimeSubject subscribeNext:^(id x) {
        [weakSelf pushToRemindListController:x];
    }];
    
    //退出该界面
    [self.scheduleModel.finishSubject subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseInforelodaData" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//- (void)updateViewConstraints {
//
//    [self.newScheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.left.bottom.mas_equalTo(0);
//        make.width.mas_equalTo(kScreen_Width);
//    }];
//
//    [super updateViewConstraints];
//}

#pragma mark - push action
-(void)pushToRemindPeopleController:(NSString *)uidStr {
    RemindPeopleVC * remindPeople = [[RemindPeopleVC alloc] init];
    remindPeople.house = self.house;
    remindPeople.schedulearruidtip = uidStr;
    [remindPeople setHidesBottomBarWhenPushed:YES];
    
    WEAKSELF;
    remindPeople.RemindPeopleBlock = ^(NSArray *array) {
        [weakSelf.newScheduleView makeRemindPeopleContent:array];
    };
    [self.navigationController pushViewController:remindPeople animated:YES];
}

-(void)pushToRemindListController:(NSNumber *)type {
    RemindListVC * remindList = [[RemindListVC alloc] init];
    remindList.scheduletiptype = [type integerValue];
    [remindList setHidesBottomBarWhenPushed:YES];
    
    WEAKSELF;
    remindList.remindListSelectBlock = ^(NSString *value, NSInteger index) {
        [weakSelf.newScheduleView makeRemindTimeContent:value withIndex:index];
    };
    [self.navigationController pushViewController:remindList animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get fun
-(NewScheduleView *)newScheduleView {
    if (!_newScheduleView) {
        _newScheduleView = [NewScheduleView shareInstanceWithViewModel:self.scheduleModel];
        _newScheduleView.frame = CGRectMake(0, 64 + kNavigationBarTop, kScreen_Width, kScreen_Height - (64 + kNavigationBarTop));
        _newScheduleView.house = self.house;
//        [_newScheduleView setRemindPeople];
    }
    return _newScheduleView;
}

-(NewScheduleModel *)scheduleModel {
    if (!_scheduleModel) {
        _scheduleModel = [[NewScheduleModel alloc] init];
        _scheduleModel.scheduleM = self.scheduleM;
        _scheduleModel.createDate = self.createDate;
    }
    return _scheduleModel;
}


/*
#pragma mark - Navigation

*/

@end
