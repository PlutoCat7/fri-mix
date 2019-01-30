//
//  CloudRecordSearchVC.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordSearchVC.h"
#import "CloudRecordSearchView.h"
#import "House.h"

@interface CloudRecordSearchVC ()
@property (strong, nonatomic) CloudRecordSearchView * searchHistoryView;

@end

@implementation CloudRecordSearchVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self bindViewModel];
}

-(void)addSubviews {
    //添加view
    [self.view addSubview:self.searchHistoryView];
}

- (void)updateViewConstraints{
    
    WS(weakSelf);
    [self.searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - model action
-(void)bindViewModel {
    
    WEAKSELF;
    [self.searchHistoryView.cancleBtnSubject subscribeNext:^(id x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - get fun
-(CloudRecordSearchView *)searchHistoryView {
    if (!_searchHistoryView) {
//        _searchHistoryView = [CloudRecordSearchView shareInstanceWithViewModel:nil withHouse:self.house];
        _searchHistoryView = [[[NSBundle mainBundle] loadNibNamed:@"CloudRecordSearchView" owner:nil options:nil] firstObject];
        _searchHistoryView.house = self.house;
        _searchHistoryView.parentVC = self;
        
    }
    return _searchHistoryView;
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
