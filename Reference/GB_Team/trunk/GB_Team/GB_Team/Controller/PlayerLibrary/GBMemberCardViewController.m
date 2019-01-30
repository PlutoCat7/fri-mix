//
//  GBMemberCardViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMemberCardViewController.h"
#import "GBHomePageViewController.h"
#import "GBNavBarSaveButton.h"
#import "GBPositionLabel.h"
#import "GBActionSheet.h"
#import "UIImageView+WebCache.h"
#import "GBPositionSelectView.h"
#import "PlayerRequest.h"
#import "GBBirthDaySelectView.h"

@interface GBMemberCardViewController () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GBBirthDaySelectViewDelegate>

// 头像图片框
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 男按钮
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
// 女按钮
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
// 电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
// 所属球队名称编辑框
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
// 姓名
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
// 年龄
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
// 球衣号码
@property (weak, nonatomic) IBOutlet UITextField *playerNumberTextField;
// 球员位置
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
// 身高
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
// 体重
@property (weak, nonatomic) IBOutlet UITextField *weghtNameTextField;
// 保存按钮
@property (nonatomic, strong) UIButton *saveButton;
// 位置1
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
// 位置2
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel2;
// 位置选择
@property (strong, nonatomic) IBOutlet GBPositionSelectView *positionSelectView;
// 生日选择视图
@property (strong, nonatomic) IBOutlet GBBirthDaySelectView *birthDaySelectView;
// 球员信息
@property (weak, nonatomic) IBOutlet UIView *albumView;
@property (strong, nonatomic) PlayerInfo *playerInfo;

@end

@implementation GBMemberCardViewController

- (instancetype)initWithPlayerInfo:(PlayerInfo *)playerInfo {
    
    if(self=[super init]){
        _playerInfo = [playerInfo copy];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

// 点击了保存按钮
- (void)actionSavePress {
    
    [self showLoadingToast];
    @weakify(self)
    [PlayerRequest editPlayer:self.playerInfo handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_EditPlayerSuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

// 点击了添加头像按钮
- (IBAction)actionAddHeadImage:(id)sender {
    
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"选择上传照片方式") button1:LS(@"拍照") button2:LS(@"从相册中选择") cancel:LS(@"取消")];
    actionSheet.delegate = self;
}

// 点击了男按钮
- (IBAction)actionMale:(id)sender {
    
    [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.maleButton.backgroundColor = [UIColor colorWithHex:0x2f2f2f];
    [self.femaleButton setTitleColor:[UIColor colorWithHex:0x626262] forState:UIControlStateNormal];
    self.femaleButton.backgroundColor = [UIColor colorWithHex:0x222222];
    
    self.playerInfo.sexType = SexType_Male;
    [self checkInputValid];
}

// 点击了女按钮
- (IBAction)actionFemale:(id)sender {
    
    [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.femaleButton.backgroundColor = [UIColor colorWithHex:0x2f2f2f];
    [self.maleButton setTitleColor:[UIColor colorWithHex:0x626262] forState:UIControlStateNormal];
    self.maleButton.backgroundColor = [UIColor colorWithHex:0x222222];
    
    self.playerInfo.sexType = SexType_Female;
    [self checkInputValid];
}

// 选择生日日期
- (IBAction)actionPressBirthDay:(id)sender {
    
    [self.view endEditing:YES];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.playerInfo.playerBirthday];
    self.birthDaySelectView = [GBBirthDaySelectView showWithDate:date];
    self.birthDaySelectView.delegate = self;
}

// 选择球员位置
- (IBAction)actionPressPosition:(id)sender {
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:self.playerInfo.position]) {
        selectList = [self.playerInfo.position componentsSeparatedByString:@","];
    }
    self.positionSelectView = [GBPositionSelectView showWithSelectList:selectList];
    @weakify(self)
    self.positionSelectView.saveBlock = ^(NSArray<NSString *>* selectIndexList){
        @strongify(self)
        [self setPositin:selectIndexList];
        [GBPositionSelectView hide];
    };
}

- (void)setPositin:(NSArray<NSString*> *)positionList {
    
    if (positionList.count == 0) {
        return;
    }
    
    NSString *position = [NSString stringWithFormat:@"%td", positionList.firstObject.integerValue];
    self.positionLabel1.hidden = NO;
    self.positionLabel1.index = positionList.firstObject.integerValue;
    if (positionList.count > 1) {
        position = [NSString stringWithFormat:@"%@,%td", position, positionList.lastObject.integerValue];
        self.positionLabel2.hidden = NO;
        self.positionLabel2.index = positionList.lastObject.integerValue;
    }
    self.positionTextField.hidden = YES;
    
    self.playerInfo.position = position;
    [self checkInputValid];
}

#pragma mark UIImagePickerControllerDelegate
#define ORIGINAL_MAX_WIDTH 240.0f
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage* pickerImage = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
        self.playerInfo.image = [pickerImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        self.headImageView.image = self.playerInfo.image;
        
        [self checkInputValid];
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark GBActionSheetDelegate
-(void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (index == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showToastWithText:LS(@"相机权限已经被您禁用，请去系统开启权限")];
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if (index == 1){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self showToastWithText:LS(@"相册权限已经被您禁用，请去系统开启权限")];
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.popoverPresentationController.sourceView = self.albumView;
        imagePicker.preferredContentSize = CGSizeMake(self.albumView.width, self.albumView.height);
        imagePicker.popoverPresentationController.permittedArrowDirections = UIMenuControllerArrowRight;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"球员信息");
    [self setupBackButtonWithBlock:^{}];
    [self setupRightButton];
    // 设置界面数据
    [self setupUIData];
    
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
}

- (void)setupUIData {
    
    if (self.playerInfo == nil) {
        return;
    }
    
    UIImage *placeholderImage = self.playerInfo.image?self.playerInfo.image:[UIImage imageNamed:@"portrait_placeholder"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.playerInfo.imageUrl] placeholderImage:placeholderImage];
    self.playerNameTextField.text = self.playerInfo.playerName;
    
//    self.phoneTextField.placeholder = LS(@"手机号码");
//    [self.phoneTextField setValue:[UIColor colorWithHex:0x7B7B83] forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneTextField.text = self.playerInfo.phone;
    
    NSDate *ageDate = [NSDate dateWithTimeIntervalSince1970:self.playerInfo.playerBirthday];
    self.ageTextField.text = [NSString stringWithFormat:@"%td-%02td-%02td", ageDate.year, ageDate.month, ageDate.day];
    self.playerNumberTextField.text = [NSString stringWithFormat:@"%td", self.playerInfo.playerNum];
    self.weghtNameTextField.text = [NSString stringWithFormat:@"%td", self.playerInfo.weight];
    self.heightTextField.text = [NSString stringWithFormat:@"%td", self.playerInfo.height];
    
    if (self.playerInfo.sexType == SexType_Male) {
        [self setupSexWithIsMale:YES];
    } else if (self.playerInfo.sexType == SexType_Female) {
        [self setupSexWithIsMale:NO];
    }
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:self.playerInfo.position]) {
        selectList = [self.playerInfo.position componentsSeparatedByString:@","];
    }
    if (selectList.count > 0) {
        self.positionLabel1.hidden = NO;
        self.positionLabel1.index = selectList.firstObject.integerValue;
        self.positionTextField.hidden = YES;
    } else {
        self.positionTextField.hidden = NO;
    }
    if (selectList.count > 1) {
        self.positionLabel2.hidden = NO;
        self.positionLabel2.index = selectList.lastObject.integerValue;
    }
}

- (void)setupRightButton {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 44)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.saveButton setTitle:LS(@"保存") forState:UIControlStateNormal];
    [self.saveButton setTitle:LS(@"保存") forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.enabled = NO;
    [self.saveButton addTarget:self action:@selector(actionSavePress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

// 设置界面呈现男或女
- (void)setupSexWithIsMale:(BOOL)ismale {
    
    if (ismale) {
        [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.maleButton.backgroundColor = [UIColor colorWithHex:0x2f2f2f];
        [self.femaleButton setTitleColor:[UIColor colorWithHex:0x626262] forState:UIControlStateNormal];
        self.femaleButton.backgroundColor = [UIColor colorWithHex:0x222222];
    } else {
        [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.femaleButton.backgroundColor = [UIColor colorWithHex:0x2f2f2f];
        [self.maleButton setTitleColor:[UIColor colorWithHex:0x626262] forState:UIControlStateNormal];
        self.maleButton.backgroundColor = [UIColor colorWithHex:0x222222];
    }
}

- (void)checkInputValid {
    
    NSString *phone = self.phoneTextField.text;
    NSString *name = self.playerNameTextField.text;
    NSString *birthday = self.ageTextField.text;
    NSString *number = self.playerNumberTextField.text;
    NSString *weight = self.weghtNameTextField.text;
    NSString *height = self.heightTextField.text;
    
    // 手机号码可选填
    self.playerInfo.phone = phone;
    self.playerInfo.playerName = name;
    self.playerInfo.playerNum = number.integerValue;
    self.playerInfo.weight = weight.integerValue;
    self.playerInfo.height = height.integerValue;
    
    BOOL isValid = ((name.length>=2 && name.length<=8) || (birthday.length>0) || (number.integerValue>=1 && number.integerValue<=99) || (weight.integerValue>=20 && weight.integerValue<=150) || (height.integerValue>=50 && height.integerValue<=250));
    BOOL isValidPos = ![NSString stringIsNullOrEmpty:self.playerInfo.position];
    BOOL isValidSex = self.playerInfo.sexType != SexType_Unknow;
    self.saveButton.enabled = isValid && isValidPos && isValidSex;
}

#pragma mark GBBirthDaySelectViewDelegate

// 日期选择器选定
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    self.playerInfo.playerBirthday = [date timeIntervalSince1970];
    self.ageTextField.text = [NSString stringWithFormat:@"%td - %02td - %02td", year, month, day];
    
    [self checkInputValid];
}
@end
