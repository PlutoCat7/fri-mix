//
//  GBNavigationController.m
//  GB_Football
//
//  Created by wsw on 16/7/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBNavigationController.h"

@interface GBNavigationController ()

@end

@implementation GBNavigationController

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
#pragma 根据颜色配置
//        self.navigationBar.barTintColor = [UIColor blackColor];  //背景色
        //[self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];  //图片设置背景色
        NSDictionary *textAttr = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:16.f]};
        [[UINavigationBar appearance] setTitleTextAttributes:textAttr]; //title字体颜色， 大小等
        self.navigationBar.translucent = NO;   //透明度
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
