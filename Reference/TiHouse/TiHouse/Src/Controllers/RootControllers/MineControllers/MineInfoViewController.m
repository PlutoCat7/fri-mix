//
//  MineInfoViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineInfoPortraitCell.h"
#import "MineInfoNicknameCell.h"
#import "EditNicknameController.h"
#import "HXPhotoPicker.h"
#import "Login.h"
#import "TOCropViewController.h"
#import "PersonProfileDataModel.h"

@interface MineInfoViewController ()<UITableViewDelegate, UITableViewDataSource, HXCustomCameraViewControllerDelegate, HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, retain) HXCustomNavigationController *nav;
@property (nonatomic, retain) TOCropViewController *cropController;

@end

@implementation MineInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User *user = [Login curLoginUser];
    
    MineInfoPortraitCell *avatarCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [avatarCell reloadImageWithImageUrl:user.urlhead];
    
    MineInfoNicknameCell *nameLabelCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [nameLabelCell reloadUsernameWithName:user.username];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = XWColorFromHex(0xF8F8F8);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
            make.bottom.equalTo(@(-kTABBARH));
        }];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[MineInfoPortraitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"portraitCellId"];
    } else {
        cell = [[MineInfoNicknameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nickNameCellId"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 70 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 10.0 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *header = [[UIView alloc] init];
        return header;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        EditNicknameController *nicknameVC = [EditNicknameController new];
        [self.navigationController pushViewController:nicknameVC animated:YES];
    } else {
        self.manager.configuration.movableCropBox = YES;
        [self selectImage];
    }
}

-(void)selectImage{
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        HXCustomCameraViewController *vc = [[HXCustomCameraViewController alloc] init];
        vc.delegate = weakSelf;
        vc.manager = weakSelf.manager;
        _nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
        _nav.isCamera = YES;
        _nav.supportRotation = self.manager.configuration.supportRotation;
        [weakSelf presentViewController:_nav animated:YES completion:nil];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *lookPhoto = [UIAlertAction actionWithTitle:@"查看大图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        XWLog(@"查看大图");
    }];
    [lookPhoto setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:action];
    [alert addAction:action1];
    //    if (!_addHouse) {
    //        [alert addAction:lookPhoto];
    //    }
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAKSELF
    
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        UIImage *image = model.previewPhoto;
        CGSize maxSize = CGSizeMake(500, 500);
        if (image.size.width > maxSize.width || image.size.height > maxSize.height) {
            
            image = [image scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
        }
        [[TiHouseNetAPIClient sharedJsonClient] uploadImage:image path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            if (responseObject) {
                [weakSelf updatePortrait:responseObject];
            }else{
                //                success(nil);
            }
        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            //            success(nil);
        } progerssBlock:^(CGFloat progressValue) {
            
        }];
        
    }else if (videoList.count > 0) {
        
    }
}

- (void)updatePortrait:(NSDictionary *)urlDic {
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editUrlhead" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"urlhead": urlDic[@"halfpath"]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [[Login curLoginUser] setUrlhead:urlDic[@"fullpath"]];
            MineInfoPortraitCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell reloadImageWithImageUrl:data[@"data"][@"urlhead"]];
            // upload userdefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *loginData = [defaults objectForKey:@"user_dict"];
            NSMutableDictionary *newLoginData = [NSMutableDictionary dictionaryWithDictionary:loginData];
            newLoginData[@"urlhead"] = urlDic[@"fullpath"];
            [defaults setObject:newLoginData forKey:@"user_dict"];
            [defaults synchronize];

        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.lookLivePhoto = YES;
//        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.singleSelected = YES;//是否单选
        _manager.configuration.supportRotation = NO;
        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.themeColor = kRKBNAVBLACK;
        _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
            //                [navigationBar setBackgroundImage:[UIImage imageNamed:@"APPCityPlayer_bannerGame"] forBarMetrics:UIBarMetricsDefault];
            navigationBar.barTintColor = kRKBNAVBLACK;
        };
        _manager.configuration.sectionHeaderTranslucent = NO;
        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        //        _manager.configuration.sectionHeaderSuspensionBgColor = kRKBViewControllerBgColor;
        _manager.configuration.sectionHeaderSuspensionTitleColor = XWColorFromHex(0x999999);
        _manager.configuration.statusBarStyle = UIStatusBarStyleDefault;
        _manager.configuration.selectedTitleColor = kRKBNAVBLACK;
        _manager.configuration.photoListBottomView = ^(HXDatePhotoBottomView *bottomView) {
            //            bottomView.bgView.barTintColor = kTiMainBgColor;
        };
        _manager.configuration.previewBottomView = ^(HXDatePhotoPreviewBottomView *bottomView) {
            //            bottomView.bgView.barTintColor = kTiMainBgColor;
        };
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.ToCarpPresetSquare = YES;
    }
    return _manager;
}

- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    [self.navigationController pushViewController:_cropController animated:NO];
    //    WEAKSELF
    //    UIImage *image = model.previewPhoto;
    //    CGSize maxSize = CGSizeMake(500, 500);
    //    if (image.size.width > maxSize.width || image.size.height > maxSize.height) {
    //
    //        image = [image scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
    //    }
    
    
}

- (void)customCameraViewControllerDidCancel:(HXCustomCameraViewController *)viewController {
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [[TiHouseNetAPIClient sharedJsonClient] uploadImage:image path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        if (responseObject) {
            [self updatePortrait:responseObject];
        }else{
            //                success(nil);
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        //            success(nil);
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    [cropViewController.navigationController popViewControllerAnimated:YES];
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

