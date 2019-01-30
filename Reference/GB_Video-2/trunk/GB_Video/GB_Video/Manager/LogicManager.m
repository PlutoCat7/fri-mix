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
#import <AssetsLibrary/AssetsLibrary.h>

#define GB_PI   3.1415926535897932384626433832795

@implementation LogicManager

+ (AreaInfo *)findAreaWithAreaList:(NSArray<AreaInfo *> *)list areaID:(NSInteger)areaID {
    
    if (!list || list.count==0) {
        return nil;
    }
    __block AreaInfo *areaInfo = nil;
    [list enumerateObjectsUsingBlock:^(AreaInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.areaID == areaID) {
            areaInfo = obj;
            return;
        }
    }];
    return areaInfo;
}

+ (AreaInfo *)findAreaWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId {
    
    AreaInfo *result = nil;
    NSArray *areaList = [RawCacheManager alloc].areaList;
    AreaInfo *provinceObj = [LogicManager findAreaWithAreaList:areaList areaID:provinceId];
    if (provinceObj != nil) {
        AreaInfo *cityObj = [LogicManager findAreaWithAreaList:provinceObj.areaChidlArray areaID:cityId];
        result = cityObj;
    }
    return result;
}

+ (NSString *)areaStringWithProvinceId:(NSInteger )provinceId cityId:(NSInteger)cityId regionId:(NSInteger)regionId {
    
    NSString *areaString = @"";
    
    NSArray *areaList = [RawCacheManager alloc].areaList;
    AreaInfo *provinceObj = [LogicManager findAreaWithAreaList:areaList areaID:provinceId];
    if (provinceObj != nil) {
        areaString = provinceObj.areaName;
        AreaInfo *cityObj = [LogicManager findAreaWithAreaList:provinceObj.areaChidlArray areaID:cityId];
        if (cityObj != nil) {
            areaString = [NSString stringWithFormat:@"%@ %@", areaString, cityObj.areaName];
            AreaInfo *regonObj = [LogicManager findAreaWithAreaList:cityObj.areaChidlArray areaID:regionId];
            if (regonObj != nil) {
                areaString = [NSString stringWithFormat:@"%@ %@", areaString, regonObj.areaName];
            }
        }
    }
    return areaString;
}


+ (BOOL)checkIsOpenNotification {
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        GBLog(@"推送被禁止");
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } title:LS(@"common.popbox.title.tip") message:@"请打开系统推送，方便您及时查看比赛结果、好友邀请" cancelButtonName:LS(@"common.btn.cancel")  otherButtonTitle:LS(@"common.btn.setting") style:GBALERT_STYLE_NOMAL];
        
        return NO;
    }else{
        GBLog(@"推送已打开");
        return YES;
    }
}

+ (BOOL)checkIsOpenCamera {

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
        GBLog(@"相机权限被禁止");
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } title:LS(@"common.popbox.title.tip") message:LS(@"personal.hint.camera.access") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.setting") style:GBALERT_STYLE_NOMAL];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkIsOpenAblum {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        
        GBLog(@"相册权限被禁止");
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } title:LS(@"common.popbox.title.tip") message:LS(@"personal.hint.album.access") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.setting") style:GBALERT_STYLE_NOMAL];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkIsOpenContact {
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0f) {
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
            
            GBLog(@"通讯录权限被禁止");
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } title:LS(@"common.popbox.title.tip") message:LS(@"personal.hint.contact.access") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.setting") style:GBALERT_STYLE_NOMAL];

            return NO;
        }
        
    }else {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
            
            GBLog(@"通讯录权限被禁止");
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } title:LS(@"common.popbox.title.tip") message:LS(@"personal.hint.contact.access") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.setting") style:GBALERT_STYLE_NOMAL];

            return NO;
        }
    }
    
    return YES;
}

@end
