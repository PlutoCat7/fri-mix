//
//  AddAddressViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/29.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "AddAddressViewController.h"

#import "AreaPickerView.h"

#import "UserRequest.h"

@interface AddAddressViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;

@end

@implementation AddAddressViewController

- (instancetype)initWithAddressModel:(AddressModel *)model {
    
    self = [super init];
    if (self) {
        _addressModel = [model copy];
        self.province = model.province;
        self.city = model.city;
        self.area = model.area;
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
    
    self.title = @"添加收货地址";
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
    
    if (_addressModel) {
        self.userNameLabel.text = _addressModel.realname;
        self.phoneTextField.text = _addressModel.mobile;
        self.regionLabel.textColor = [UIColor colorWithHex:0x68696A];
        self.regionLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
        self.detailAddressTextView.text = _addressModel.address;
        _placeholderLabel.hidden = YES;
    }
}

- (void)setupNavigationBarRight {
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setSize:CGSizeMake(48, 24)];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitle:@"保存" forState:UIControlStateHighlighted];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

#pragma mark - Action

- (IBAction)actionRegion:(id)sender {
    
    [self.userNameLabel resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.detailAddressTextView resignFirstResponder];
    @weakify(self)
    [AreaPickerView showWithHandler:^(NSString *province, NSString *city, NSString *area) {
        
        @strongify(self)
        self.province = province;
        self.city = city;
        self.area = area;
        self.regionLabel.textColor = [UIColor colorWithHex:0x68696A];
        self.regionLabel.text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    }];
}

- (void)actionSave {
    
    NSString *userName = self.userNameLabel.text;
    NSString *phone = self.phoneTextField.text;
    NSString *detailAddress = self.detailAddressTextView.text;
    
    if (userName.length<=0) {
        [self showToastWithText:@"请填写收货人姓名"];
        return;
    }
    
    if (![LogicManager isPhoneBumber:phone]) {
        [self showToastWithText:@"请输入正确的手机号码"];
        return;
    }
    
    if (self.province.length==0 || self.city.length==0) {
        [self showToastWithText:@"请选择地区"];
        return;
    }
    
    if (detailAddress.length<=0) {
        [self showToastWithText:@"请输入详细地址"];
        return;
    }
    
    //网络请求
    [self showLoadingToast];
    [UserRequest saveAddressWithName:userName phone:phone address:detailAddress province:self.province city:self.city area:self.area addressId:(_addressModel)?_addressModel.addressId:nil handler:^(id result, NSError *error) {
       
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[UIApplication sharedApplication].keyWindow showToastWithText:@"保存成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Address_Add_OR_Edit object:nil];
        }
    }];

}

#pragma mark - Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeholderLabel.hidden = NO;
    }
    
    return YES;
}

@end
