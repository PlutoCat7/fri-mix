//
//  GBGameTracticsViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTracticsViewController.h"

#import "GBCourtLineUpView.h"

#import "GBGameTracticsViewModel.h"

@interface GBGameTracticsViewController ()

@property (weak, nonatomic) IBOutlet GBCourtLineUpView *courtTracticsView;
@property (weak, nonatomic) IBOutlet UILabel *tracticeNameLabel;

@property (nonatomic, strong) GBGameTracticsViewModel *viewModel;

@end

@implementation GBGameTracticsViewController

- (instancetype)initWithTracticsType:(TracticsType)type players:(NSArray<TeamLineUpInfo *> *)players {
    
    self = [super init];
    if (self) {
        
        _viewModel = [[GBGameTracticsViewModel alloc] initWithTracticsType:type players:players];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tracticeNameLabel.text = [NSString stringWithFormat:@"%@ : %@", LS(@"team.data.record.tractics"), (self.viewModel.tracticsModel)?self.viewModel.tracticsModel.name:LS(@"team.info.name.empty")];
    self.courtTracticsView.dataList = self.viewModel.dataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getViewShareImage {
    
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[self.view] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    return shareImage;
}

@end
