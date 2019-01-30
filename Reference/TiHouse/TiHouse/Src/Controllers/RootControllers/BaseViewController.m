//
//  BaseViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "YYFPSLabel.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRKBViewControllerBgColor;
    [self wr_setNavBarBarTintColor:kTiMainBgColor];
    [self wr_setNavBarTitleColor:kRKBNAVBLACK];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    
    
//    YYFPSLabel *label = [[YYFPSLabel alloc] initWithFrame:CGRectMake(90, 0, 100, 20)];
//    [[UIApplication sharedApplication].keyWindow addSubview:label];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setIsExtendLayout:(BOOL)isExtendLayout {
    _isExtendLayout = isExtendLayout;
    
    if (!isExtendLayout) {
        [self initializeSelfVCSetting];
    } else {
        [self initializeSelfVCSetting1];
    }
}

- (void)initializeSelfVCSetting {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop; //导航栏透明
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initializeSelfVCSetting1 {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone; //导航栏不透明
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - lift cycle

#pragma mark - UITableViewDelegate

#pragma mark - CustomDelegate

#pragma mark - event response


#pragma mark - private methods 私有方法


#pragma mark - getters and setters

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
