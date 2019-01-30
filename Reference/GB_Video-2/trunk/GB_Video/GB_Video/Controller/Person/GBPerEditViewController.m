//
//  GBPerEditViewController.m
//  GB_Video
//
//  Created by gxd on 2018/1/31.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBPerEditViewController.h"
#import "GBPersonViewController.h"
#import "GBPerNameViewController.h"
#import "GBPerSexViewController.h"
#import "GBPerRegionViewController.h"

#import "SettingTextTableViewCell.h"
#import "SettingPhotoTableViewCell.h"
#import "GBSettingConstant.h"
#import "UIImageView+WebCache.h"

#import "ResourceRequest.h"
#import "UserRequest.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface GBPerEditViewController () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GBPerEditViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBPersonViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - NSNotification

- (void)userInfoChangeNotification {
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangeNotification) name:Notification_User_BaseInfo object:nil];
}

- (void)setupUI {
    
    self.title = LS(@"personal.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingPhotoTableViewCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Setter and Getter

- (NSArray<NSString *> *)titleList {
    
    return @[LS(@"personal.label.head"), LS(@"personal.label.nickname"), LS(@"personal.label.gender"), LS(@"personal.label.region")];
}


- (NSArray<NSString *> *)descList {
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    NSString *imageUrl = userInfo.imageUrl == nil ? @"" : userInfo.imageUrl;
    NSString *name = [NSString stringIsNullOrEmpty:userInfo.nick] ? userInfo.phone : userInfo.nick;
    NSString *sex = @"未选择";
    if (userInfo.sexType == SexType_Female) {
        sex = LS(@"personal.label.female");
    }else if (userInfo.sexType == SexType_Male) {
        sex = LS(@"personal.label.male");
    }
    NSString *area = [LogicManager areaStringWithProvinceId:userInfo.provinceId cityId:userInfo.cityId regionId:userInfo.regionId];
    
    return @[imageUrl, name, sex, area];
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SettingPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingPhotoTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.row];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.descList[indexPath.row]] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
        return cell;
    }
    SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
    cell.titleLabel.text = self.titleList[indexPath.row];
    cell.descLabel.text = self.descList[indexPath.row];
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SettingPhotoCellHeight;
    }
    return SettingTextCellHeight;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15*kAppScale;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self clickPhotoCell];
        }else if (indexPath.row == 1) {
            [self clickNameCell];
        }else if (indexPath.row == 2) {
            [self clickSexCell];
        }else if (indexPath.row == 3) {
            [self clickAreaCell];
        }
    }
}

- (void)clickPhotoCell {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LS(@"选择上传照片方式")
                                                             delegate:self
                                                    cancelButtonTitle:LS(@"取消")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LS(@"从手机相册中选择"), LS(@"照相"), nil];
    [actionSheet showInView:self.view];
}

- (void)clickNameCell {
    GBPerNameViewController *nameViewController = [[GBPerNameViewController alloc] initWithTitle:LS(@"personal.label.nickname") placeholder:LS(@"personal.placeholder.nickname")];
    nameViewController.defaltName = [RawCacheManager sharedRawCacheManager].userInfo.nick;
    nameViewController.minLenght = 2;
    nameViewController.maxLength = 20;
    [self.navigationController pushViewController:nameViewController animated:YES];
}

- (void)clickSexCell {
    GBPerSexViewController *sexViewController = [[GBPerSexViewController alloc] initWithSex:[RawCacheManager sharedRawCacheManager].userInfo.sexType];
    [self.navigationController pushViewController:sexViewController animated:YES];
}

- (void)clickAreaCell {
    UserInfo *tmpUserInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    GBPerRegionViewController *regionViewController = [[GBPerRegionViewController alloc] initWithRegion:tmpUserInfo.provinceId cityId:tmpUserInfo.cityId];
    [self.navigationController pushViewController:regionViewController animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showToastWithText:LS(@"personal.hint.camera.access")];
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if (buttonIndex == 0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self showToastWithText:LS(@"personal.hint.album.access")];
            return;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showLoadingToastWithText:LS(@"personal.hint.upload.avatar")];
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        fixImage = [fixImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        
        
        @weakify(self)
        [ResourceRequest uploadUserPhoto:fixImage handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (!error) {
                UserImageUploadInfo *imageInfo = result;
                @weakify(self)
                UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
                userInfo.imageUrl = imageInfo.realImageurl;
                [UserRequest updateUserInfo:userInfo handler:^(id result, NSError *error) {
                    
                    @strongify(self)
                    if (!error) {
                        [self dismissToast];
                        [self.tableView reloadData];
                    }else {
                        [self showToastWithText:error.domain];
                    }
                }];
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

@end
