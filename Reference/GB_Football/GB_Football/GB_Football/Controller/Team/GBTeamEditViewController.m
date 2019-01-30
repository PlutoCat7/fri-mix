//
//  GBTeamEditViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamEditViewController.h"
#import "GBMenuViewController.h"
#import "GBPesonNameViewController.h"
#import "GBTeamReginViewController.h"
#import "GBTeamInstrViewController.h"

#import "SettingAvatorTableViewCell.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"
#import "SettingMutilTextTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "GBActionSheet.h"
#import "GBSingleActionSheet.h"
#import "GBDatePicker.h"
#import "GBAlertViewOneWay.h"

#import "TeamRequest.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface GBTeamEditViewController () <
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GBDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TeamInfo *teamInfo;
@property (nonatomic, assign) BOOL isLeader;

@property (nonatomic, strong) UIImage *selectedAvatorImage;

@end

@implementation GBTeamEditViewController

- (instancetype)initWithLeader:(TeamInfo *)teamInfo {
    if (self = [super init]) {
        _teamInfo = teamInfo;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Action

- (void)rightBarAction {
    if (self.isLeader) {
        [GBActionSheet showWithTitle:LS(@"team.setting.choose.nav.title")
                             button1:LS(@"team.setting.choose.label.disband")
                             button2:LS(@"team.setting.choose.label.quit")
                              cancel:LS(@"common.btn.cancel")
                              handle:^(NSInteger index) {
                                  if (index == 0) {
                                      [self actionDisbandTeam];
                                  }else if (index == 1) {
                                      [self actionQuitTeamHint];
                                  }
                              }];
    } else {
        [GBSingleActionSheet showWithTitle:LS(@"team.setting.choose.nav.title")
                             button1:LS(@"team.setting.choose.label.quit")
                              cancel:LS(@"common.btn.cancel")
                              handle:^(NSInteger index) {
                                  if (index == 0) {
                                      [self actionQuitTeam];
                                  }
                              }];
    }
    
}

- (void)actionDisbandTeam {
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [TeamRequest disbandTeam:^(id result, NSError *error) {
                @strongify(self)
                if (error) {
                    [self showToastWithText:error.domain];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_RemoveSuccess object:nil];
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"team.setting.choose.hint.disband") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

- (void)actionQuitTeamHint {
    [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"team.setting.choose.hint.leader.quit") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
}

- (void)actionQuitTeam {
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [TeamRequest quitTeam:^(id result, NSError *error) {
                @strongify(self)
                if (error) {
                    [self showToastWithText:error.domain];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_RemoveSuccess object:nil];
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"team.setting.choose.hint.player.quit") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}



#pragma mark - Private

- (void)loadData {
    UserInfo *userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
    self.isLeader = (userInfo.userId == self.teamInfo.leaderId);
}

- (void)setupUI {
    
    self.title = LS(@"team.info.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupNavigationBarRight];
    [self setupTableView];
}

- (void)setupNavigationBarRight {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"more"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)] animated:YES];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingAvatorTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingAvatorTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingMutilTextTableViewCell" bundle:nil]forCellReuseIdentifier:@"SettingMutilTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return  @[@[LS(@"team.setting.label.logo"), LS(@"team.setting.label.name"), LS(@"team.setting.label.date"), LS(@"team.setting.label.city")],
              @[LS(@"")]];
}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    NSString *imageUrl = self.teamInfo.teamIcon;
    NSString *nickName = self.teamInfo.teamName;
    
    NSDate *foundDate = [NSDate dateWithTimeIntervalSince1970:self.teamInfo.foundTime];
    NSString *dateString = [NSString stringWithFormat:@"%td-%02td-%02td", foundDate.year, foundDate.month, foundDate.day];
    NSString *region = [LogicManager areaStringWithProvinceId:self.teamInfo.provinceId cityId:self.teamInfo.cityId regionId:0];
    NSString *introduct = self.teamInfo.teamInstr;
    
    return  @[@[imageUrl,
                nickName,
                dateString,
                region?region:@""],
              @[introduct?introduct:@""]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@"",
             LS(@"team.setting.label.introduct")];
}

- (void)syncUserData {
    
    [TeamRequest modifyTeamInfo:self.teamInfo handler:^(id result, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }else {
            [self showToastWithText:error.domain];
        }
    }];
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
    [self showLoadingToastWithText:LS(@"team.setting.hint.upload.logo")];
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        fixImage = [fixImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        
        @weakify(self)
        [TeamRequest uploadTeamLogo:fixImage handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (!error) {
                self.teamInfo.teamIcon = result;
                self.selectedAvatorImage = image;
                [self.tableView reloadData];
                
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

#pragma mark GBDatePickerDelegate
// 日期选择器返回
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
{
    self.teamInfo.foundTime = date.timeIntervalSince1970;
    [self.tableView reloadData];
    
    [self syncUserData];
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
        [cell hideArrowImageView:!self.isLeader];
        
        return cell;
        
    } else if (indexPath.section == 0) {
        SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
        cell.descLabel.text = self.descList[indexPath.section][indexPath.row];
        [cell hideArrowImageView:!self.isLeader];
        
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        SettingMutilTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingMutilTextTableViewCell"];
        [cell hideArrowImageView:!self.isLeader];
        [cell setIntroductionText:self.descList[indexPath.section][indexPath.row]];
        
        return cell;
    }
    
    return nil;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return 67*kAppScale;
    } else if (indexPath.section == 0) {
        return 50*kAppScale;
    } else {
        UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
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
    
    if (!self.isLeader) {
        return;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self clickAvatorCell];
                break;
            case 1:
                [self clickTeamNameCell];
                break;
            case 2:
                [self clickTeamDateCell];
                break;
            case 3:
                [self clickTeamAreaCell];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self clickTeamIntroductCell];
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

- (void)clickTeamNameCell {
    GBPesonNameViewController *nameViewController = [[GBPesonNameViewController alloc] initWithTitle:LS(@"team.setting.label.name") placeholder:LS(@"team.setting.placeholder.name")];
    nameViewController.defaltName = self.teamInfo.teamName;
    nameViewController.minLenght = 2;
    nameViewController.maxLength = 16;
    nameViewController.saveBlock = ^(NSString *name){
        
        TeamInfo *tempTeam = [self.teamInfo copy];
        tempTeam.teamName = name;
        
        [self.navigationController.topViewController showLoadingToast];
        @weakify(self)
        [TeamRequest modifyTeamInfo:tempTeam handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self.navigationController.topViewController dismissToast];
            if (!error) {
                self.teamInfo.teamName = name;
                [self.tableView reloadData];
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }else {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }
        }];
        
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
}

- (void)clickTeamAreaCell {
    GBTeamReginViewController *vc = [[GBTeamReginViewController alloc] initWithAreaList:[RawCacheManager sharedRawCacheManager].areaList selectRegion:[LogicManager areaStringWithProvinceId:self.teamInfo.provinceId cityId:self.teamInfo.cityId regionId:0] level:2];
    vc.isShowSelectRegion = YES;
    vc.saveBlock = ^(AreaInfo *province, AreaInfo *city, AreaInfo *region) {
        
        TeamInfo *tempTeam = [self.teamInfo copy];
        tempTeam.provinceId = province ? province.areaID : 0;
        tempTeam.cityId = city ? city.areaID : 0;
        [self.navigationController.topViewController showLoadingToast];
        @weakify(self)
        [TeamRequest modifyTeamInfo:tempTeam handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self.navigationController.topViewController dismissToast];
            if (!error) {
                self.teamInfo.provinceId = province ? province.areaID : 0;
                self.teamInfo.cityId = city ? city.areaID : 0;
                [self.tableView reloadData];
            }else {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }
        }];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickTeamDateCell {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.teamInfo.foundTime];
    GBDatePicker *datePicker = [GBDatePicker showWithDate:date title:LS(@"team.setting.hint.date")];
    datePicker.delegate = self;
}

- (void)clickTeamIntroductCell {
    GBTeamInstrViewController *viewController = [[GBTeamInstrViewController alloc] initWithTitle:LS(@"team.info.nav.title") content:self.teamInfo.teamInstr];
    viewController.minLenght = 0;
    viewController.maxLength = 60;
    viewController.saveBlock = ^(NSString *name){
        
        TeamInfo *tempTeam = [self.teamInfo copy];
        tempTeam.teamInstr = name;
        
        [self.navigationController.topViewController showLoadingToast];
        @weakify(self)
        [TeamRequest modifyTeamInfo:tempTeam handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self.navigationController.topViewController dismissToast];
            if (!error) {
                self.teamInfo.teamInstr = name;
                [self.tableView reloadData];
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }else {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }
        }];
        
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
