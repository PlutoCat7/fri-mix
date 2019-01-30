//
//  UIImagePickerController+Nonrotating.m
//  GB_Team
//
//  Created by weilai on 16/9/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UIImagePickerController+Nonrotating.h"
#import "AppDelegate.h"

@implementation UIImagePickerController (Nonrotating)

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isPhotoLibrary = YES;
}

- (void)dealloc {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isPhotoLibrary = NO;
}

// 指定 UIImagePickerController 只支持横屏方向
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

// 设置状态栏的状态
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
