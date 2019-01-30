//
//  SelectHouseTypeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "SelectHouseTypeViewController.h"
#import "AddSubtractButton.h"

@interface SelectHouseTypeViewController ()

@property (nonatomic, retain) UILabel *titleSrt;

@end

@implementation SelectHouseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择户型";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];

    [self.view addSubview:self.titleSrt];
    
    AddSubtractButton *aa = [[AddSubtractButton alloc]initWithFrame:CGRectMake(20, 88 + kSTATUSBARHANDNAV, kScreen_Width-40, 50) Itemtitles:@[@"室",@"厅"]];
    if (_ValuesDic) {
        UILabel *room = (UILabel *)[aa viewWithTag:10];
        UIButton *roomBtn = (UIButton *)[aa viewWithTag:11];
        room.text = aa.Values[0] = _ValuesDic[@"room"];
        if ([_ValuesDic[@"room"] intValue]) {
            roomBtn.enabled = YES;
        }
        UILabel *hall = (UILabel *)[aa viewWithTag:13];
        UIButton *hallBtn = (UIButton *)[aa viewWithTag:14];
        hall.text = aa.Values[1] = _ValuesDic[@"hall"];
        if ([_ValuesDic[@"hall"] intValue]) {
            hallBtn.enabled = YES;
        }
    }
    
    aa.AddSubtractBlock = ^(NSMutableArray *Values, UIButton *btn) {
        [self.ValuesDic setValue:Values[0] forKey:@"room"];
        [self.ValuesDic setValue:Values[1] forKey:@"hall"];
    };
    [self.view addSubview:aa];
    
    
    
    AddSubtractButton *bb = [[AddSubtractButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(aa.frame)+10, kScreen_Width-40, 50) Itemtitles:@[@"厨",@"卫"]];
    if (_ValuesDic) {
        UILabel *kitchen = (UILabel *)[bb viewWithTag:10];
        UIButton *kitchenBtn = (UIButton *)[bb viewWithTag:11];
        kitchen.text = bb.Values[0] = _ValuesDic[@"kitchen"];
        if ([_ValuesDic[@"kitchen"] intValue]) {
            kitchenBtn.enabled = YES;
        }
        
        UILabel *toilet = (UILabel *)[bb viewWithTag:13];
        UIButton *toiletBtn = (UIButton *)[bb viewWithTag:14];
        toilet.text = bb.Values[1] = _ValuesDic[@"toilet"];
        if ([_ValuesDic[@"toilet"] intValue]) {
            toiletBtn.enabled = YES;
        }
    }
    bb.AddSubtractBlock = ^(NSMutableArray *Values, UIButton *btn) {
        [self.ValuesDic setValue:Values[0] forKey:@"kitchen"];
        [self.ValuesDic setValue:Values[1] forKey:@"toilet"];
    };
    [self.view addSubview:bb];
    
    
    AddSubtractButton *cc = [[AddSubtractButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(bb.frame)+10, kScreen_Width-40, 50) Itemtitles:@[@"阳台"]];
    if (_ValuesDic) {
        UILabel *kitchen = (UILabel *)[cc viewWithTag:10];
        UIButton *kitchenBtn = (UIButton *)[cc viewWithTag:11];
        kitchen.text = cc.Values[0] = _ValuesDic[@"balcony"];
        if ([_ValuesDic[@"balcony"] intValue]) {
            kitchenBtn.enabled = YES;
        }
    }
    cc.AddSubtractBlock = ^(NSMutableArray *Values, UIButton *btn) {
        [self.ValuesDic setValue:Values[0] forKey:@"balcony"];
    };
    [self.view addSubview:cc];

    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_titleSrt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(kSTATUSBARHANDNAV));
        make.height.equalTo(@(88));
    }];
    

}
#pragma mark - event response
//点击完成
-(void)finish{
    if (self.SelectedHouseType) {
        self.SelectedHouseType(self.ValuesDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods 私有方法


#pragma mark - getters and setters
-(UILabel *)titleSrt{
    if (!_titleSrt) {
        _titleSrt = [[UILabel alloc]init];
        _titleSrt.text = @"请选择您的户型";
        _titleSrt.textAlignment = NSTextAlignmentCenter;
        _titleSrt.textColor = XWColorFromHex(0x333333);
        _titleSrt.font = [UIFont systemFontOfSize:24];
        _titleSrt.backgroundColor = [UIColor clearColor];
    }
    return _titleSrt;
}

-(NSMutableDictionary *)ValuesDic{
    
    if (!_ValuesDic) {
        _ValuesDic = [NSMutableDictionary new];
        [_ValuesDic setObject:@"1" forKey:@"room"];
        [_ValuesDic setObject:@"1" forKey:@"hall"];
        [_ValuesDic setObject:@"1" forKey:@"kitchen"];
        [_ValuesDic setObject:@"1" forKey:@"toilet"];
        [_ValuesDic setObject:@"1" forKey:@"balcony"];
    }
    return _ValuesDic;
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
