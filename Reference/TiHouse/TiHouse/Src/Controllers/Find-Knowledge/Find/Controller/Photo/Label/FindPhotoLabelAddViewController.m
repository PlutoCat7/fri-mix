//
//  FindPhotoLabelDesc1ViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelAddViewController.h"
#import "FindPhotoLabelNameViewController.h"
#import "FindPhotoLabelPriceViewController.h"

#import "UIViewController+YHToast.h"

@interface FindPhotoLabelAddViewController ()

@property (weak, nonatomic) IBOutlet UILabel *thingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thingBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *thingPriceLabel;

@property (nonatomic, copy) NSString *thingName;
@property (nonatomic, copy) NSString *thingBrand;
@property (nonatomic, copy) NSString *thingPrice;

@property (nonatomic, copy) void(^doneBlock)(NSString *thingName, NSString *brand, NSString *price);

@end

@implementation FindPhotoLabelAddViewController

- (instancetype)initWithDoneBlock:(void(^)(NSString *thingName, NSString *brand, NSString *price))doneBlock {
    
    self = [super init];
    if (self) {
        _doneBlock = doneBlock;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"添加物品";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Action

- (void)doneAction {
    
    if (_thingName==nil ||
        _thingName.length == 0) {
        [self showToastWithText:@"请填写物品名称"];
        return;
    }
    if (_doneBlock) {
        _doneBlock(_thingName, _thingBrand, _thingPrice);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionName:(id)sender {
    
    WEAKSELF
    FindPhotoLabelNameViewController *vc = [[FindPhotoLabelNameViewController alloc] initWithPlaceholder:@"请输入物品名称，如：沙发、餐桌" text:_thingName isBrand:NO doneBlock:^(NSString *inputName) {
        
        weakSelf.thingName = inputName;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionBrandName:(id)sender {
    
    WEAKSELF
    FindPhotoLabelNameViewController *vc = [[FindPhotoLabelNameViewController alloc] initWithPlaceholder:@"(选填)请输入品牌名称，如：宜家、科勒" text:_thingBrand isBrand:YES doneBlock:^(NSString *inputName) {
        
        weakSelf.thingBrand = inputName;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionPrice:(id)sender {
    
    WEAKSELF
    FindPhotoLabelPriceViewController *vc = [[FindPhotoLabelPriceViewController alloc] initWithPlaceholder:@"(选填)请输入价格" text:_thingPrice doneBlock:^(NSString *inputName) {
        
        weakSelf.thingPrice = inputName;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter and Getter

- (void)setThingName:(NSString *)thingName {
    
    _thingName = thingName;
    if ([thingName isEmpty]) {
        _thingNameLabel.textColor = [UIColor colorWithRGBHex:0x9d9d9d];
        _thingNameLabel.text = @"请输入物品名称，如：沙发、餐桌";
    }else {
        _thingNameLabel.textColor = [UIColor blackColor];
        _thingNameLabel.text = thingName;
    }
}

- (void)setThingBrand:(NSString *)thingBrand {
    
    _thingBrand = thingBrand;
    if ([thingBrand isEmpty]) {
        _thingBrandLabel.textColor = [UIColor colorWithRGBHex:0x9d9d9d];
        _thingBrandLabel.text = @"(选填)请输入品牌名称，如：宜家、科勒";
    }else {
        _thingBrandLabel.textColor = [UIColor blackColor];
        _thingBrandLabel.text = thingBrand;
    }
}

- (void)setThingPrice:(NSString *)thingPrice {
    
    _thingPrice = thingPrice;
    if ([thingPrice isEmpty]) {
        _thingPriceLabel.textColor = [UIColor colorWithRGBHex:0x9d9d9d];
        _thingPriceLabel.text = @"(选填)请输入价格";
    }else {
        _thingPriceLabel.textColor = [UIColor blackColor];
        _thingPriceLabel.text = thingPrice;
    }
}

@end
