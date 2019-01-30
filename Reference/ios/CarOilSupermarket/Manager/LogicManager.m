//
//  LogicManager.m
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LogicManager.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import<AssetsLibrary/AssetsLibrary.h>

#import "LoginViewController.h"

@implementation LogicManager

+ (BOOL)checkIsOpenCamera {

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
        GBLog(@"相机权限被禁止");
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } title:@"温馨提示" message:@"相机权限已经被您禁用，请去系统开启权限" cancelButtonName:@"取消" otherButtonTitles:@"设置", nil];

        return NO;
    }
    
    return YES;
}

+ (BOOL)checkIsOpenAblum {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        
        GBLog(@"相册权限被禁止");
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } title:@"温馨提示" message:@"相册权限已经被您禁用，请去系统开启权限" cancelButtonName:@"取消" otherButtonTitles:@"设置", nil];
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPhoneBumber:(NSString *)phone {
    
    if ([phone isPureInt] && [phone hasPrefix:@"1"] && phone.length == 11) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidInputCode:(NSString *)code {
    
    if (code.length>=1 && code.length<=10) {
        return YES;
    }
    return NO;
}

+ (BOOL)isUserLogined {
    
    if (![RawCacheManager sharedRawCacheManager].userInfo) {
        return NO;
    }
    return YES;
}

+ (void)pushLoginViewControllerWithNav:(UINavigationController *)nav {
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
}

@end
