//
//  GBPersonInfoViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPersonInfoViewController.h"
#import "GBPesonNameViewController.h"
#import "GBGenderViewController.h"
#import "GBPersonDetailViewController.h"
#import "GBPersonReginViewController.h"

#import "SettingAvatorTableViewCell.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"

#import "UIImageView+WebCache.h"
#import "GBActionSheet.h"
#import "GBDatePicker.h"

#import "UserRequest.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface GBPersonInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GBDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIImage *selectedAvatorImage;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation GBPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)loadData {
    
    self.userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
}

- (void)setupUI {
    
    self.title = LS(@"setting.label.personal");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingAvatorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingAvatorTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return  @[@[LS(@"personal.label.avator"), LS(@"personal.label.nickname_new"), LS(@"personal.label.birthday_new"), LS(@"personal.label.gender_new"), LS(@"personal.label.region_new")],
              @[LS(@"personal.label.player")]];
}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
    
    NSString *imageUrl = userInfo.imageUrl?userInfo.imageUrl:@"";
    NSString *nickName = userInfo.nick?userInfo.nick:@"";
    NSString *birthDateString = [NSString stringWithFormat:@"%td-%02td-%02td", birthDate.year, birthDate.month, birthDate.day];
    NSString *gender = userInfo.sexType==SexType_Male?LS(@"personal.label.male"):LS(@"personal.label.female");
    NSString *region = [LogicManager areaStringWithProvinceId:userInfo.provinceId cityId:userInfo.cityId regionId:userInfo.regionId];
    
    return  @[@[imageUrl,
                nickName,
                birthDateString,
                gender,
                region?region:@""],
              @[@""]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@"",
             LS(@"personal.team.title")];
}

- (void)syncUserData {
    
    [UserRequest updateUserInfo:self.userInfo handler:^(id result, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }else {
            [self showToastWithText:error.domain];
        }
    }];
}

#pragma mark - Delegate

#pragma mark GBDatePickerDelegate
// 日期选择器返回
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
{
    self.userInfo.birthday = date.timeIntervalSince1970;
    [self.tableView reloadData];
    
    [self syncUserData];
}

#pragma mark GBActionSheetDelegate

- (void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index {
    
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
                self.userInfo.imageUrl = result;
                self.selectedAvatorImage = image;
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Avator object:image];
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

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        SettingAvatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingAvatorTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
        if (self.selectedAvatorImage) {//取已选择的图片
            cell.avatorImageView.image = self.selectedAvatorImage;
        }else {
            [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.descList[indexPath.section][indexPath.row]] placeholderImage:[UIImage imageNamed:@"portrait"]];
        }
        
        return cell;
    }else {
        SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
        cell.descLabel.text = self.descList[indexPath.section][indexPath.row];
        
        return cell;
    }
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return 67*kAppScale;
    }else {
        return 50*kAppScale;
    }
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = self.sectionTitleList[section];
    if (![NSString stringIsNullOrEmpty:sectionTitle]) {
        return 48*kAppScale;
    }else {
        return 15*kAppScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SettingSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SettingSectionHeaderView"];
    headerView.titleLabel.text= self.sectionTitleList[section];
    
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self clickAvatorCell];
                break;
            case 1:
                [self clickNickNameCell];
                break;
            case 2:
                [self clickBirthDayCell];
                break;
            case 3:
                [self clickGenderCell];
                break;
            case 4:
                [self clickAreaCell];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self clickTeamCell];
                break;
        
            default:
                break;
        }
    }
}

- (void)clickAvatorCell {
    
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"personal.hint.choose.method") button1:LS(@"personal.hint.take.photo") button2:LS(@"personal.hint.choose.photo") cancel:LS(@"common.btn.cancel")];
    actionSheet.delegate = self;
}

- (void)clickNickNameCell {
    
    GBPesonNameViewController *nameViewController = [[GBPesonNameViewController alloc] initWithTitle:LS(@"personal.label.nickname") placeholder:LS(@"personal.placeholder.nickname")];
    nameViewController.defaltName = self.userInfo.nick;
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
                [self.tableView reloadData];
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }else {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }
        }];
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
}

- (void)clickBirthDayCell {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.userInfo.birthday];
    GBDatePicker *datePicker = [GBDatePicker showWithDate:date];
    datePicker.delegate = self;
}

- (void)clickGenderCell {
    
    [self.navigationController pushViewController:[GBGenderViewController new] animated:YES];
}
- (void)clickAreaCell {
    
    GBPersonReginViewController *vc = [[GBPersonReginViewController alloc] initWithAreaList:[RawCacheManager sharedRawCacheManager].areaList selectRegion:[LogicManager areaStringWithProvinceId:self.userInfo.provinceId cityId:self.userInfo.cityId regionId:self.userInfo.regionId]];
    vc.isShowSelectRegion = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickTeamCell {
    
    [self.navigationController pushViewController:[GBPersonDetailViewController new] animated:YES];
}

@end
