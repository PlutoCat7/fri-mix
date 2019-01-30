//
//  GBTeamCreateViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamCreateViewController.h"
#import "GBMenuViewController.h"
#import "GBPesonNameViewController.h"
#import "GBTeamReginViewController.h"
#import "GBTeamInstrViewController.h"

#import "UIImageView+WebCache.h"
#import "GBActionSheet.h"
#import "GBDatePicker.h"
#import "GBHightLightButton.h"

#import "TeamRequest.h"

#define ORIGINAL_MAX_WIDTH 240.0f

@interface GBTeamCreateViewController () <
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
GBActionSheetDelegate,
GBDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIView *avatorContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamFoundTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamAddrLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamInstroductLbl;
@property (weak, nonatomic) IBOutlet GBHightLightButton *createButton;

@property (weak, nonatomic) IBOutlet UILabel *teamLogoStLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamNameStLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamFoundTimeStLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamAddrStLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamInstroductStLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamHintStLbl;

@property (nonatomic, strong) TeamInfo *teamInfo;
@property (nonatomic, strong) UIImage *selectedAvatorImage;

@end

@implementation GBTeamCreateViewController

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
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}


#pragma mark - action
- (IBAction)actionTeamLogo:(id)sender {
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"personal.hint.choose.method") button1:LS(@"personal.hint.take.photo") button2:LS(@"personal.hint.choose.photo") cancel:LS(@"common.btn.cancel")];
    actionSheet.delegate = self;
}

- (IBAction)actionTeamName:(id)sender {
    GBPesonNameViewController *nameViewController = [[GBPesonNameViewController alloc] initWithTitle:LS(@"team.setting.label.name") placeholder:LS(@"team.setting.placeholder.name")];
    nameViewController.defaltName = self.teamInfo.teamName;
    nameViewController.minLenght = 2;
    nameViewController.maxLength = 16;
    nameViewController.saveBlock = ^(NSString *name){
        
        self.teamInfo.teamName = name;
        [self setupTeamInfoUI];
        
        [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
        
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
}

- (IBAction)actionTeamFoundTime:(id)sender {
    NSDate *date = [NSDate date];
    if (self.teamInfo.foundTime != 0) {
        date = [NSDate dateWithTimeIntervalSince1970:self.teamInfo.foundTime];
    }
    
    GBDatePicker *datePicker = [GBDatePicker showWithDate:date title:LS(@"team.setting.hint.date")];
    datePicker.delegate = self;
}

- (IBAction)actionTeamAddress:(id)sender {
    GBTeamReginViewController *vc = [[GBTeamReginViewController alloc] initWithAreaList:[RawCacheManager sharedRawCacheManager].areaList selectRegion:[LogicManager areaStringWithProvinceId:self.teamInfo.provinceId cityId:self.teamInfo.cityId regionId:0] level:2];
    vc.isShowSelectRegion = YES;
    vc.saveBlock = ^(AreaInfo *province, AreaInfo *city, AreaInfo *region) {
        self.teamInfo.provinceId = province ? province.areaID : 0;
        self.teamInfo.cityId = city ? city.areaID : 0;
        
        NSString *address = [NSString stringWithFormat:@"%@ %@", (province ? province.areaName : @""), (city ? city.areaName : @"")];
        self.teamAddrLbl.text = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.teamAddrLbl.textColor = [UIColor colorWithHex:0x909090];
        
        [self setupTeamInfoUI];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionTeamIntroduct:(id)sender {
    GBTeamInstrViewController *viewController = [[GBTeamInstrViewController alloc] initWithTitle:LS(@"team.info.nav.title") content:self.teamInfo.teamInstr];
    viewController.minLenght = 0;
    viewController.maxLength = 60;
    viewController.saveBlock = ^(NSString *name){
        
        self.teamInfo.teamInstr = name;
        [self setupTeamInfoUI];
        
        [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
        
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionTeamCreate:(id)sender {
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest createTeamInfo:self.teamInfo handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (!error) {
            if (self.selectedAvatorImage) {
                [TeamRequest uploadTeamLogo:self.selectedAvatorImage handler:^(id result, NSError *error) {
                    [self dismissToast];
                    if (!error) {
                        self.teamInfo.teamIcon = result;
                        [RawCacheManager sharedRawCacheManager].userInfo.team_mess.teamIcon = result;
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_CreateSuccess object:nil];
                    [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
                }];
                
            } else {
                [self dismissToast];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_CreateSuccess object:nil];
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }
            
        }else {
            [self dismissToast];
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
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage* fixImage = [UIImage fixOrientation:image];
        fixImage = [fixImage imageScaledToSize:CGSizeMake(ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_WIDTH)];
        self.selectedAvatorImage = fixImage;
        
        [self setupTeamInfoUI];
        
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
    [self setupTeamInfoUI];
}

#pragma mark - Private
- (void)localizeUI {
    self.teamLogoStLbl.text = LS(@"team.setting.label.logo");
    self.teamNameStLbl.text = LS(@"team.setting.label.name");
    self.teamFoundTimeStLbl.text = LS(@"team.setting.label.date");
    self.teamAddrStLbl.text = LS(@"team.setting.label.city");
    self.teamInstroductStLbl.text = LS(@"team.setting.label.introduct");
    self.teamHintStLbl.text = LS(@"team.setting.label.hint");
    
    self.teamNameLbl.text = LS(@"team.setting.hint.name");
    self.teamFoundTimeLbl.text = LS(@"team.setting.hint.date");
    self.teamAddrLbl.text = LS(@"team.setting.hint.city");
    self.teamInstroductLbl.text = LS(@"team.setting.hint.introduct");
    
}


- (void)setupUI {
    
    self.title = LS(@"team.setting.nav.create");
    [self setupBackButtonWithBlock:nil];
    
    self.avatorContainerView.layer.cornerRadius = self.avatorContainerView.width/2;
    self.teamLogoImageView.layer.cornerRadius = self.teamLogoImageView.width/2;
    
    self.teamInfo = [[TeamInfo alloc] init];
}

- (void)setupTeamInfoUI {
    BOOL btnVaild = YES;
    if (self.selectedAvatorImage) {
        self.teamLogoImageView.image = self.selectedAvatorImage;
    }
    
    UIColor *normalColor = [UIColor colorWithHex:0x909090];
    UIColor *placeHolderColor = [UIColor colorWithHex:0x5b5b5b]
    ;    if (self.teamInfo.teamName.length > 0) {
        self.teamNameLbl.text = self.teamInfo.teamName;
        self.teamNameLbl.textColor = normalColor;
    } else {
        self.teamNameLbl.text = LS(@"team.setting.hint.name");
        self.teamNameLbl.textColor = placeHolderColor;
        btnVaild = NO;
    }
    
    if (self.teamInfo.foundTime != 0) {
        NSDate *foundDate = [NSDate dateWithTimeIntervalSince1970:self.teamInfo.foundTime];
        self.teamFoundTimeLbl.text = [NSString stringWithFormat:@"%td-%02td-%02td", foundDate.year, foundDate.month, foundDate.day];
        self.teamFoundTimeLbl.textColor = normalColor;
    } else {
        self.teamFoundTimeLbl.text = LS(@"team.setting.hint.date");
        btnVaild = NO;
        self.teamFoundTimeLbl.textColor = placeHolderColor;
    }
    
    if (self.teamInfo.provinceId == 0 || self.teamInfo.cityId == 0) {
        btnVaild = NO;
    }
    
    if (self.teamInfo.teamInstr.length > 0) {
        self.teamInstroductLbl.text = self.teamInfo.teamInstr;
        self.teamInstroductLbl.textColor = normalColor;
    } else {
        self.teamInstroductLbl.text = LS(@"team.setting.hint.introduct");
        self.teamInstroductLbl.textColor = placeHolderColor;
    }
    
    self.createButton.enabled = btnVaild;
}


@end
