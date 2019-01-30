//
//  YHImagePickerRootViewController.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerRootViewController.h"
#import "YAHImagePickerViewController.h"
#import "YAHPhotoTools.h"
#import "TJPlayerViewController.h"
#import "YAHImagePeckerAssetsData.h"

#import <AVFoundation/AVFoundation.h>

@interface YAHImagePickerRootViewController ()

@property (nonatomic, strong) UINavigationController *nav;

@end

@implementation YAHImagePickerRootViewController

- (void)dealloc
{
    [YAHImagePeckerAssetsData destroyInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxVideoDuration = 10;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    YAHImagePickerViewController *vc = [[YAHImagePickerViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    vc.dismissBlock = ^() {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.dismissBlock) {
            strongSelf.dismissBlock(strongSelf);
        }
    };
    vc.failureBlock = ^(NSError *error) {
      
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.failureBlock) {
            strongSelf.failureBlock(strongSelf, error);
        }
    };
    vc.sucessBlock = ^(NSArray<YAHPhotoModel *> *assets) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (assets.firstObject.asset.mediaType == PHAssetMediaTypeVideo) {
            [strongSelf.nav.topViewController.view showLoadingToastWithText:LS(@"game.complete.video.handle")];
            //获取视频
            [YAHPhotoTools getAVAssetWithPHAsset:assets.firstObject.asset progressHandler:^(PHAsset *asset, double progress) {
                NSLog(@"download:%lf", progress);
            } completion:^(PHAsset *asset, AVAsset *avasset) {
                //压缩视频并生成临时文件
                [YAHPhotoTools compressedVideoWithMediumQualityWriteToTemp:avasset progress:nil success:^(NSURL *url) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                        [strongSelf.nav.topViewController.view dismissToast];
                        if ((NSInteger)asset.duration > strongSelf.maxVideoDuration) { //弹出视频编辑界面
                            TJPlayerViewController *pvc = [[TJPlayerViewController alloc] init];
                            pvc.videoUrl = url;
                            pvc.videoLimitTime = strongSelf.maxVideoDuration;
                            pvc.cutDoneBlock = ^(NSURL *url) {
                                
                                assets.firstObject.videoUrl = url;
                                if (strongSelf.sucessBlock) {
                                    strongSelf.sucessBlock(strongSelf, assets);
                                }
                            };
                            [strongSelf.nav.topViewController presentViewController:pvc animated:YES completion:nil];
                        }else {
                            assets.firstObject.videoUrl = url;
                            if (strongSelf.sucessBlock) {
                                strongSelf.sucessBlock(strongSelf, assets);
                            }
                        }
                    });
                } failure:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.nav.topViewController.view showToastWithText:LS(@"game.complete.video.handle.fail")];
                        if (strongSelf.failureBlock) {
                            strongSelf.failureBlock(strongSelf, [NSError errorWithDomain:LS(@"game.complete.video.handle.fail") code:0 userInfo:nil]);
                        }
                    });
                }];
                
            } failed:^(PHAsset *asset, NSDictionary *info) {
                NSLog(@"error:%@", info);
                [strongSelf.nav.topViewController.view showToastWithText:LS(@"game.complete.video.handle.fail")];
                if (strongSelf.failureBlock) {
                    strongSelf.failureBlock(strongSelf, [NSError errorWithDomain:LS(@"game.complete.video.handle.fail") code:0 userInfo:nil]);
                }
            }];
        }else {
            if (strongSelf.sucessBlock) {
                strongSelf.sucessBlock(strongSelf, assets);
            }
        }
    };
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.view addSubview:self.nav.view];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Accessors

- (void)setSelectAssets:(NSArray<YAHPhotoModel *> *)selectAssets {
    
    _selectAssets = selectAssets;
    [[YAHImagePeckerAssetsData shareInstance] addAssetWithArray:selectAssets];
}

- (void)setMaximumNumberOfSelection:(NSInteger)maximumNumberOfSelection {
    
    _maximumNumberOfSelection = maximumNumberOfSelection;
    [YAHImagePeckerAssetsData shareInstance].maximumNumberOfSelection = maximumNumberOfSelection;
}

- (void)setImagePickerFilterType:(YAHImagePickerFilterType)imagePickerFilterType {
    
    _imagePickerFilterType = imagePickerFilterType;
    [YAHImagePeckerAssetsData shareInstance].filterType = imagePickerFilterType;
}

@end


@implementation YAHImagePickerRootViewController (camera)

+ (BOOL)isCameraDeviceAvailable {
    
    BOOL isHaveCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isHaveCamera) {
        isHaveCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    }
    return isHaveCamera;
}

+ (BOOL)canAccessCamera {
    
    // iOS7可以禁用相机，需要相机权限判断，判断相机是否开启;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        if((NSInteger)[AVCaptureDevice performSelector:(@selector(authorizationStatusForMediaType:)) withObject:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
            return NO;
        }
    }
    
    return YES;
    
    //提示
//    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
//    NSString *message = [NSString stringWithFormat:@"请在iPad的\"设置-隐私-相机\"中允许%@访问您的相机",appName];
//    [[[UIAlertView alloc] initWithTitle:@"相机被禁用"
//                                message:message
//                               delegate:nil
//                      cancelButtonTitle:@"确定"
//                      otherButtonTitles:nil] show];
}

@end
