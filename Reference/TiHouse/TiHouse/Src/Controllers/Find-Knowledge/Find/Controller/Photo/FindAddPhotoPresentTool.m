//
//  FindAddPhotoPresentTool.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAddPhotoPresentTool.h"
#import "FindPhotoHandleViewController.h"
#import "FindPhotoPostViewController.h"
#import "FindCloudPhotoViewController.h"
#import "FindCloudEditViewController.h"

#import "HXPhotoPicker.h"
#import "TOCropViewController.h"

@interface FindAddPhotoPresentTool () <
HXAlbumListViewControllerDelegate,
HXCustomCameraViewControllerDelegate,
TOCropViewControllerDelegate,
FindCloudPhotoViewControllerDelegate
>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, retain) TOCropViewController *cropController;

@end

@implementation FindAddPhotoPresentTool

- (void)presentToolWithViewController:(UIViewController *)viewController {
    
    _viewController = viewController;
    [viewController hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
//    WEAKSELF
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *ablumAction = [UIAlertAction actionWithTitle:@"从用户相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf.viewController hx_presentAlbumListViewControllerWithManager:weakSelf.manager delegate:weakSelf];
//    }];
//    [ablumAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//    UIAlertAction *cloudAction = [UIAlertAction actionWithTitle:@"从云记录选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//        FindCloudPhotoViewController *vc = [[FindCloudPhotoViewController alloc] init];
//        vc.delegate = weakSelf;
//        HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
//        [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
//    }];
//    [cloudAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
//
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
//
//    [alert addAction:ablumAction];
//    [alert addAction:cloudAction];
//    [alert addAction:action2];
//    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)dismiss {
    
    [self.viewController.navigationController popToViewController:self.viewController animated:YES];
}

- (void)pushPhotoPostVCWith:(NSArray<FindPhotoHandleModel *> *)photoModelList {
    
    FindPhotoPostViewController *postVC = [[FindPhotoPostViewController alloc] initWithWithPhotoModelList:photoModelList];
    NSMutableArray *vcList = [NSMutableArray arrayWithArray:self.viewController.navigationController.viewControllers];
    while (1) {
        if ([vcList.lastObject isKindOfClass:[self.viewController class]]) {
            break;
        }
        [vcList removeLastObject];
    }
    [vcList addObject:postVC];
    [self.viewController.navigationController setViewControllers:[vcList copy] animated:YES];
}

#pragma mark - Setter and Getter

- (HXPhotoManager *)manager {
    _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    _manager.configuration.photoMaxNum = 9;
    _manager.configuration.hideOriginalBtn = YES;
    return _manager;
}


#pragma mark - HXAlbumListViewControllerDelegate

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:photoList doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self pushPhotoPostVCWith:photoModelList];
    }];
    [self.viewController.navigationController pushViewController:vc animated:NO];
}

#pragma mark - HXCustomCameraViewControllerDelegate

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    _cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= NO;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    _cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
    
    [self.viewController.navigationController pushViewController:_cropController animated:NO];
}

#pragma mark - FindCloudPhotoViewControllerDelegate

- (void)findCloudPhotoViewControllerDidDone:(NSArray<FindCloudCellModel *> *)selectModels {
    FindCloudEditViewController *vc = [[FindCloudEditViewController alloc] initWithCloudPhotos:selectModels];
    [self.viewController.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
    photoModel.thumbPhoto = image;
    photoModel.previewPhoto = image;
    @weakify(self)
    FindPhotoHandleViewController *vc = [[FindPhotoHandleViewController alloc] initWithPhotoList:@[photoModel] doneBlock:^(NSArray<FindPhotoHandleModel *> *photoModelList) {
        
        @strongify(self)
        [self pushPhotoPostVCWith:photoModelList];
    }];
    [self.viewController.navigationController pushViewController:vc animated:NO];
}

@end
