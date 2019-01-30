//
//  PointsDescViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/28.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "PointsDescViewController.h"

@interface PointsDescViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, copy) NSString *infos;

@end

@implementation PointsDescViewController

- (instancetype)initWithInfos:(NSString *)infos {
    
    self = [super init];
    if (self) {
        _infos = infos;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"积分规则";
    [self setupBackButtonWithBlock:nil];
    
    self.infoLabel.text = _infos;
}

@end
