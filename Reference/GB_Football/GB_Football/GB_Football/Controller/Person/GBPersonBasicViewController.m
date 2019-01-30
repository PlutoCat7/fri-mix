//
//  GBPersonBasicViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPersonBasicViewController.h"
#import "GBPersonDetailViewController.h"
#import "GBWelComeViewController.h"
#import "GBPesonNameViewController.h"
#import "GBDatePicker.h"
#import "GBSexPicker.h"
#import "GBCityPicker.h"
#import "GBHightLightButton.h"
#import "UserRequest.h"
#import "UIImageView+WebCache.h"
#import "GBActionSheet.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface GBPersonBasicViewController () <
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBDatePickerDelegate,
GBSexPickerDelegate,
GBCityPickerDelegate,
GBActionSheetDelegate
>

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
// 绿色的加号
@property (weak, nonatomic) IBOutlet UIImageView *addItem;
// 姓名标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 出生日标签
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
// 性别标签
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
// 地区标签
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
// 高亮按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *headStLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameStLbl;
@property (weak, nonatomic) IBOutlet UILabel *birthdayStLbl;
@property (weak, nonatomic) IBOutlet UILabel *sexStLbl;
@property (weak, nonatomic) IBOutlet UILabel *aearStLbl;

// 动作表单
@property (strong, nonatomic) GBActionSheet *actionSheet;
// 日期选择器
@property (strong, nonatomic) GBDatePicker *datePicker;
// 性别选择器
@property (strong, nonatomic) GBSexPicker  *sexPicker;
// 日期选择器
@property (strong, nonatomic) GBCityPicker *cityPicker;

@property (nonatomic, assign) BOOL isSetNickName;
@property (nonatomic, assign) BOOL isSetBirthday;
@property (nonatomic, assign) BOOL isSetSex;
@property (nonatomic, assign) BOOL isSetArea;

@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation GBPersonBasicViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (void)localizeUI {
    self.headStLbl.text = LS(@"personal.label.head");
    self.nameStLbl.text = LS(@"personal.label.nickname");
    self.birthdayStLbl.text = LS(@"personal.label.birthday");
    self.sexStLbl.text = LS(@"personal.label.gender");
    self.aearStLbl.text = LS(@"personal.label.region");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.isNeedNext) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    if (self.userInfo.birthday>0) { //从选择年龄返回，重新设置生日
        NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:self.userInfo.birthday];
        self.birthLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", birthDate.year, birthDate.month, birthDate.day];
        self.birthLabel.textColor = [ColorManager textColor];
        self.isSetBirthday = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isNeedNext) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.isNeedNext) {
        if ([self.navigationController.topViewController isMemberOfClass:[GBWelComeViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        }
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headImgView.layer.cornerRadius = self.headImgView.width/2;
        self.headImgView.clipsToBounds = YES;
    });
}

#pragma mark - Notification

#pragma mark - Delegate

#pragma mark GBDatePickerDelegate
// 日期选择器返回
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
{
    self.userInfo.birthday = date.timeIntervalSince1970;
    self.birthLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", year, month, day];
    self.birthLabel.textColor = [ColorManager textColor];
    self.isSetBirthday = YES;
    [self checkInputValid];
}

#pragma mark GBSexPickerDelegate
// 性别选择器返回
- (void)didSelectSexIndex:(NSInteger)index
{
    if (index == 0) {
        self.userInfo.sexType = SexType_Male;
        self.sexLabel.text = LS(@"personal.label.male");
    }else if (index == 1){
        self.userInfo.sexType = SexType_Female;
        self.sexLabel.text = LS(@"personal.label.female");
    }
    self.sexLabel.textColor = [ColorManager textColor];
    self.isSetSex = YES;
    [self checkInputValid];
}

#pragma mark GBAreaPickerDelegate
// 地区选择器返回
- (void)didSelectAreaString:(NSString *)string provinceId:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId;
{
    self.userInfo.provinceId = provinceId;
    self.userInfo.cityId = cityId;
    self.userInfo.regionId = areaId;
    self.areaLabel.text = string;
    self.areaLabel.textColor = [ColorManager textColor];
    self.isSetArea = YES;
    [self checkInputValid];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showLoadingToastWithText:LS(@"personal.hint.upload.avatar")];
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        fixImage = [fixImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        
        @weakify(self)
        [UserRequest uploadUserPhoto:fixImage handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (!error) {
                self.addItem.hidden = YES;
                self.headImgView.image = image;
                self.userInfo.imageUrl = result;
            }else {
                [self showToastWithText:error.domain];
            }
        }];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

// 选择头像按钮
- (IBAction)actionSelectHeadImage:(id)sender {
    
    [self showActionSheet];
}

// 点击输入姓名
- (IBAction)actionInputName:(id)sender {
    
    GBPesonNameViewController *nameViewController = [[GBPesonNameViewController alloc] initWithTitle:LS(@"personal.label.nickname") placeholder:LS(@"personal.placeholder.nickname")];
    nameViewController.defaltName = self.isSetNickName?self.nameLabel.text:@"";
    nameViewController.minLenght = 2;
    nameViewController.maxLength = 16;
    nameViewController.saveBlock = ^(NSString *name){
        
        [self.navigationController.topViewController showLoadingToast];
        @weakify(self)
        [UserRequest checkUserNickName:name handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self.navigationController.topViewController dismissToast];
            if (!error) {
                self.userInfo.nick = name;
                self.isSetNickName = YES;
                self.nameLabel.text = name;
                self.nameLabel.textColor = [ColorManager textColor];
                [self checkInputValid];
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }else {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }
        }];
        
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
    
}
// 点击输入生日
- (IBAction)actionInputBirth:(id)sender {
    
    NSDate *date = nil;
    if (self.userInfo.birthday>0) {
        date = [NSDate dateWithTimeIntervalSince1970:self.userInfo.birthday];
    }
    self.datePicker = [GBDatePicker showWithDate:date];
    self.datePicker.delegate = self;
}

// 点击输入性别
- (IBAction)actionInputSex:(id)sender {
    
    NSInteger index = (self.userInfo.sexType == SexType_Male)?0:1;
    self.sexPicker = [GBSexPicker showWithIndex:index];
    self.sexPicker.delegate = self;
}

// 点击输入地区
- (IBAction)actionInputArea:(id)sender {
    self.cityPicker = [GBCityPicker show:self.userInfo.provinceId cityId:self.userInfo.cityId areaId:self.userInfo.regionId];
    self.cityPicker.delegate = self;
}

// 点击注册下一步
- (IBAction)actionNext:(id)sender {
    
    if (self.isNeedNext) {
        [RawCacheManager sharedRawCacheManager].userInfo = self.userInfo;
        GBPersonDetailViewController *vc = [[GBPersonDetailViewController alloc]init];
        vc.isNeedNext = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showLoadingToast];
        @weakify(self)
        [UserRequest updateUserInfo:self.userInfo handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (!error) {
                
                [RawCacheManager sharedRawCacheManager].userInfo = self.userInfo;
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self showToastWithText:error.domain];
            }
        }];
    }
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"setting.label.personal");
    if (self.isNeedNext) {
        [self.navigationItem setHidesBackButton:YES];
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        
        //头像
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
        
        if (![NSString stringIsNullOrEmpty:self.userInfo.nick]) {
            self.nameLabel.text = self.userInfo.nick;
            self.isSetNickName = YES;
            self.nameLabel.textColor = [ColorManager textColor];
        }
        self.sexLabel.text = LS(@"personal.label.male");
        self.sexLabel.textColor = [ColorManager textColor];
        self.isSetSex = YES;
    }else {
        [self setupBackButtonWithBlock:nil];
        //头像
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
        
        self.isSetNickName = YES;
        self.nameLabel.text = self.userInfo.nick;;
        self.nameLabel.textColor = [ColorManager textColor];
        
        //生日
        NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:self.userInfo.birthday];
        self.birthLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", birthDate.year, birthDate.month, birthDate.day];
        self.birthLabel.textColor = [ColorManager textColor];
        self.isSetBirthday = YES;
        //性别
        if (self.userInfo.sexType == SexType_Male) {
            self.sexLabel.text = LS(@"personal.label.male");
        }else {
            self.sexLabel.text = LS(@"personal.label.female");
        }
        self.sexLabel.textColor = [ColorManager textColor];
        self.isSetSex = YES;
        //地区
        self.areaLabel.text = [LogicManager areaStringWithProvinceId:self.userInfo.provinceId cityId:self.userInfo.cityId regionId:self.userInfo.regionId];
        self.areaLabel.textColor = [ColorManager textColor];
        self.isSetArea = YES;
        
        [self.nextButton setTitle:@"OK" forState:UIControlStateNormal];
        
        [self checkInputValid];
    }
}

-(void)loadData
{
    self.userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
    if (self.isNeedNext) { //性别默认男性
        self.userInfo.sexType = SexType_Male;
    }
}

- (void)checkInputValid {
    
    self.nextButton.enabled = self.isSetNickName && self.isSetBirthday && self.isSetSex && self.isSetArea;
}

-(void)showActionSheet{
    self.actionSheet = [GBActionSheet showWithTitle:LS(@"personal.hint.choose.method") button1:LS(@"personal.hint.take.photo") button2:LS(@"personal.hint.choose.photo") cancel:LS(@"common.btn.cancel")];
    self.actionSheet.delegate = self;
}

-(void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (index == 0) {
        if (![LogicManager checkIsOpenCamera]) {
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if (index == 1){
        if (![LogicManager checkIsOpenAblum]) {
            return;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - Getters & Setters

@end
