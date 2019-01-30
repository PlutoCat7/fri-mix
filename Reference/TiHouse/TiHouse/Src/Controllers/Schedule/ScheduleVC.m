//
//  ScheduleVC.m
//  TiHouse
//  日程
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleVC.h"
#import "ScheduleListVC.h"
#import "ScheduleDayVC.h"
#import "EventPopAlertView.h"
#import "NewScheduleVC.h"
#import "Login.h"

@interface ScheduleVC ()

@end

@implementation ScheduleVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleColorSelected = XWColorFromRGB(253, 191, 48);  //选中时标题的颜色
        self.titleColorNormal = [UIColor blackColor];    //没有选中时的颜色
        self.titleSizeNormal = 17;
        self.titleSizeSelected = 17;
        self.menuViewStyle = WMMenuViewStyleLine;  //设置下划线显示
        self.progressHeight = 3;
        self.progressWidth = 30;
        self.scrollEnable = NO;
    }
    return self;
}

-(NSArray<NSString *> *)titles {
    return @[@"列表",@"日历"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.menuView setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.menuView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.view addSubview:self.menuView];
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addEvent:)];
    
}

- (void)addEvent:(UIBarButtonItem *)sender{
    if (_house.uidcreater != [Login curLoginUser].uid) {
        [NSObject showHudTipStr:@"亲友不能创建日程"];
        return;
    }
    NewScheduleVC * newSch = [[NewScheduleVC alloc] init];
    newSch.house = self.house;
    [newSch setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:newSch animated:YES];
}



-(CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake((kScreen_Width - 140) / 2, 20, 140, 43);
}

-(CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    UIViewController *vc = nil;
    if (index == 0) {
        ScheduleListVC  *svc = [[ScheduleListVC alloc] init];
        svc.house = self.house;
        vc = svc;
        
    } else {
        ScheduleDayVC  *dvc = [[ScheduleDayVC alloc] init];
        dvc.house = self.house;
        vc = dvc;
    }
    
    return vc;
}

//- (WMMenuItem *)menuView:(WMMenuView *)menu initialMenuItem:(WMMenuItem *)initialMenuItem atIndex:(NSInteger)index {
////    if (index == self.selectIndex) {
////
////    } else {
////        [initialMenuItem setFont:[UIFont systemFontOfSize:17]];
////    }
//    [initialMenuItem setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
//    return initialMenuItem;
//}

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
