//
//  FindArticleUploadCoverViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleUploadCoverViewController.h"
#import "FindDraftViewController.h"
#import "UIViewController+YHToast.h"
#import "FindArticlePreViewController.h"

#import "FindManager.h"
#import "TOCropViewController.h"
#import "HXPhotoPicker.h"
#import "AssemarcRequest.h"
#import "NotificationConstants.h"
#import "UIImage+Resize.h"

@interface FindArticleUploadCoverViewController () <
HXAlbumListViewControllerDelegate,
HXCustomCameraViewControllerDelegate,
TOCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *posButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *previewButton;

@property (nonatomic, strong) FindDraftSaveModel *saveModel;

@end

@implementation FindArticleUploadCoverViewController

- (instancetype)initWithSaveDraftInfo:(FindDraftSaveModel *)saveModel {
    
    self = [super init];
    if (self) {
        _saveModel = saveModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.posButton.layer.cornerRadius = self.posButton.height/2;
    });
}

#pragma mark - Action

- (IBAction)actionUpload:(id)sender {
    
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"用户相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentCustomCameraViewControllerWithManager:weakSelf.manager delegate:weakSelf];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionSave {
    
    self.saveModel.editTimeInterval = [NSDate date].timeIntervalSince1970;
    [FindManager modifyOrInsertDraftWithModel:self.saveModel];
    [NSObject showHudTipStr:self.view tipStr:@"保存成功"];
//    NSMutableArray *vcList = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [vcList removeLastObject];
//    [vcList removeLastObject];
//    if ([vcList.lastObject isKindOfClass:[FindDraftViewController class]]) {
//        [vcList removeLastObject];
//    }
//    FindDraftViewController *vc = [FindDraftViewController new];
//    [vcList addObject:vc];
//
//    [self.navigationController setViewControllers:[vcList copy] animated:YES];
    
}

- (void)actionNext { //预览
    
    //保存一次
    self.saveModel.editTimeInterval = [NSDate date].timeIntervalSince1970;

    FindArticlePreViewController *vc = [[FindArticlePreViewController alloc] initWithSaveDraftInfo:self.saveModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionPost:(id)sender {
    
    [self showLoadingToast];
    [AssemarcRequest postArticleWithAssemarctitle:_saveModel.title urlindex:_saveModel.coverHalfImageUrl assemarccontent:_saveModel.htmlString handler:^(id result, NSError *error) {
        [self dismissToast];
        if (!error) {//发布成功跳转
            [FindManager deleteDraftWithModel:self.saveModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Posted_Article object:nil];
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:self.previewButton];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtn1];
    
    if (self.saveModel.coverFullImageUrl) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.saveModel.coverFullImageUrl]];
    }
    [self checkInputValid];
}

- (void)checkInputValid {
    
    self.previewButton.enabled = NO;
    self.saveButton.enabled = NO;
    self.posButton.enabled = NO;
    self.posButton.backgroundColor = [UIColor colorWithRGBHex:0xFEF9CF];
    self.tipsLabel.text = @"上传封面";
    if (self.saveModel.coverHalfImageUrl &&
        ![self.saveModel.coverHalfImageUrl isEmpty]) {
        self.previewButton.enabled = YES;
        self.saveButton.enabled = YES;
        self.posButton.enabled = YES;
        self.posButton.backgroundColor = [UIColor colorWithRGBHex:0xFDF086];
        self.tipsLabel.text = @"修改封面";
    }
    if (self.saveModel.coverHalfImageUrl &&
        ![self.saveModel.coverHalfImageUrl isEmpty]) {
        self.previewButton.enabled = YES;
        self.saveButton.enabled = YES;
        self.posButton.enabled = YES;
        self.posButton.backgroundColor = [UIColor colorWithRGBHex:0xFDF086];
        self.tipsLabel.text = @"修改封面";
    }
}

- (void)uploadCoverImage:(UIImage *)image {
    
    [self showLoadingToast];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[TiHouse_NetAPIManager sharedManager] request_uploadFilesWithData:imageData completedUsing:^(NSString *data, NSError *error) {
        if (!error) {
            NSString *imageUrl = data.length > 0 ? [NSString stringWithFormat:@"/%@",data]:@"";
            [[TiHouseNetAPIClient sharedJsonClient] POST:@"api/outer/upload/getFullpath" parameters:@{@"pathhalf":imageUrl} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self dismissToast];
                self.coverImageView.image = image;
                self.saveModel.coverImageWidth = image.size.width;
                self.saveModel.coverImageHeight = image.size.height;
                
                self.saveModel.coverHalfImageUrl = imageUrl;
                self.saveModel.coverFullImageUrl = [responseObject[@"data"] objectForKey:@"fullpath"];
                
                [self checkInputValid];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self dismissToast];
            }];
        }else {
            [self dismissToast];
        }
    }];
}

#pragma mrak - Setter and Getter

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.size = CGSizeMake(kRKBWIDTH(50), 44);
    }
    return _saveButton;
}

- (UIButton *)previewButton {
    
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(actionNext) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.size = CGSizeMake(kRKBWIDTH(50), 44);
    }
    return _previewButton;
}

- (HXPhotoManager *)manager
{
    
        HXPhotoManager *_manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
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
    _manager.configuration.movableCropBoxCustomRatio = CGPointMake(375, 190);
    
    return _manager;
}

#pragma mark - Delegate

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAKSELF
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        UIImage *uploadImage = model.previewPhoto;
        if (!uploadImage) {
            uploadImage = model.thumbPhoto;
        }
        [weakSelf uploadCoverImage:uploadImage];
    }else if (videoList.count > 0) {
        
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController.navigationController popViewControllerAnimated:YES];
    UIImage *uploadImage = image;
    [self uploadCoverImage:uploadImage];
}

- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    TOCropViewController *_cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    
    _cropController.aspectRatioLockEnabled = YES;
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
    _cropController.customAspectRatio = CGSizeMake(375, 190);
    [self.navigationController pushViewController:_cropController animated:NO];
}

@end
