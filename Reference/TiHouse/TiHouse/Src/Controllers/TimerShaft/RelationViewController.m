//
//  RelationViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelationViewController.h"
#import "RelationView.h"
#import "BaseNavigationController.h"

@interface RelationViewController ()
{
    NSString *_title;
    NSInteger _item;
}
@end

@implementation RelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"完善您与房屋的关系";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    RelationView *relationView = [[RelationView alloc]init];
    relationView.backgroundColor = [UIColor whiteColor];
    relationView.house = _house;

    if (_house.houseid) {
        WEAKSELF
        [[TiHouse_NetAPIManager sharedManager] request_RelativeAndFriendHousepersonWithPath:URL_Get_RelFri_List Params:@{@"houseid":@(_house.houseid)} Block:^(id data, NSError *error) {
            if (data) {
                relationView.masters = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"typerelation=1 || typerelation=2"]];
                relationView.finishBolck = ^(NSString *ValueStr, NSInteger item) {
                    _title = ValueStr;
                    _item = item;
                };
                
                [self.view addSubview:relationView];
                if (_selectedBtn) {
                    relationView.selectedBtn = _selectedBtn;
                }
                [relationView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@(110));
                    make.top.equalTo(@(kDevice_Is_iPhoneX ? 88 : 64));
                }];
                
            } else {
                [NSObject showError:error];
            }
        }];
    } else {
        relationView.finishBolck = ^(NSString *ValueStr, NSInteger item) {
            _title = ValueStr;
            _item = item;
        };
        
        [self.view addSubview:relationView];
        if (_selectedBtn) {
            relationView.selectedBtn = _selectedBtn;
        }
        [relationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(110));
            make.top.equalTo(@(kDevice_Is_iPhoneX ? 88 : 64));
        }];

    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  showNavBottomLine];
}


#pragma mark - event response
//点击完成
-(void)finish{
    [self.navigationController popViewControllerAnimated:YES];
    if (_finishBolck) {
        _finishBolck(_title,_item);
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
