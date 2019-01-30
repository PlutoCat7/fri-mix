//
//  LogicManager.m
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LogicManager.h"
#import "BluUtility.h"
#import "GBBluetoothManager.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import<AssetsLibrary/AssetsLibrary.h>

#import "DailyRequest.h"

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

+ (NSString *)chinesePositonWithIndex:(NSInteger)index {

    NSArray *list = @[LS(@"position.label.gk"), LS(@"position.label.lb"), LS(@"position.label.cb"), LS(@"position.label.rb"), LS(@"position.label.dmf"), LS(@"position.label.lmf"), LS(@"position.label.cmf"), LS(@"position.label.rmf"), LS(@"position.label.amf"), LS(@"position.label.lwf"), LS(@"position.label.ss"), LS(@"position.label.rwf"), LS(@"position.label.cf")];
    @try {
        return list[index];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        
    }
}

+ (NSString *)englishPositonWithIndex:(NSInteger)index {
    
    NSArray *list = @[@"GK", @"LB", @"CB", @"RB", @"DMF", @"LMF", @"CMF", @"RMF", @"AMF", @"LWF", @"SS", @"RWF", @"CF"];
    @try {
        return list[index];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        
    }
}

+ (UIColor *)positonColorWithIndex:(NSInteger)index {
    
    UIColor *color = [UIColor whiteColor];
    if (index == 0) {
        color = [UIColor colorWithHex:0xffd800];
    }else if (index>0 && index<=3) {
        color = [UIColor colorWithHex:0x01c5ff];
    }else if (index>3 && index<=8) {
        color = [UIColor colorWithHex:0x00ffac];
    }else if (index>8 && index<=12) {
        color = [UIColor colorWithHex:0xd10001];
    }
    return color;
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

+ (BOOL)checkExistUserInfo {

    if ([RawCacheManager sharedRawCacheManager].userInfo.nick == nil || [RawCacheManager sharedRawCacheManager].userInfo.nick.length == 0 || [RawCacheManager sharedRawCacheManager].userInfo.position.length == 0)
    {
        return NO;
    }
    return YES;
}

+ (NSArray *)transformPointArray:(NSArray *)fourPoints origPoints:(NSArray *)origPoints size:(CGSize)size tansX:(BOOL)tansX tansY:(BOOL)transY {

    if (fourPoints == nil || origPoints == nil) {
        return nil;
    }
    
    NSMutableArray *tFourPoints = [NSMutableArray new];
    [tFourPoints addObjectsFromArray:fourPoints];
    if (tFourPoints == nil || [tFourPoints count] != 6) {
        return nil;
    }
    
    NSMutableArray *transPoints = [NSMutableArray new];
    // 最小外切矩形的size,原始坐标系是左上角为原点
    NSValue *sizeValue = tFourPoints[4];
    CGSize tempSize = [sizeValue CGSizeValue];
    CGSize tSize = CGSizeMake(tempSize.height, tempSize.width);
    // 旋转角度,原始坐标系是左上角为原点,所以使用的角度要使用补角
    double angleValue = fabs(90 - fabs([tFourPoints[5] doubleValue]));
    double angle = fabs(angleValue)*GB_PI/180.f;
    // 如果角度为90度，需要再做一次转换，转为0度的情况,主要时角度变为0度，x，y轴对调
    if (angleValue == 90) {
        angle = fabs(90 - angleValue)*GB_PI/180.f;
        tSize = CGSizeMake(tSize.height, tSize.width);
    }
    
    // 坐标系转换的参照点
    CGPoint referPoint = CGPointMake(0, 0);
    int index = -1;
    for (int i = 0; i < 4; i++) {
        NSValue *pointValue = tFourPoints[i];
        CGPoint point = [pointValue CGPointValue];
        
        if (index == -1) {
            referPoint.x = point.x;
            referPoint.y = point.y;
            index = i;
            continue;
        }
        
        if (referPoint.y > point.y) {
            referPoint.x = point.x;
            referPoint.y = point.y;
        } else if (referPoint.y == point.y && referPoint.x > point.x) {
            referPoint.x = point.x;
            referPoint.y = point.y;
        }
    }
    
    // 转化坐标系
    for (NSValue *origPoint in origPoints) {
        CGPoint oPoint = [origPoint CGPointValue];
        
        NSValue *tPointValue = [self transformPoint:oPoint referPoint:referPoint origSize:size tranSize:tSize angle:angle tansX:tansX tansY:transY];
        if (tPointValue != nil) {
            [transPoints addObject:tPointValue];
        }
    }
    
    return transPoints;
}

// 转换单点坐标系
+ (NSValue *)transformPoint:(CGPoint)point referPoint:(CGPoint)referPoint origSize:(CGSize)origSize tranSize:(CGSize)tranSize angle:(double)angle tansX:(BOOL)tansX tansY:(BOOL)transY
{
    CGFloat xDist = (point.x - referPoint.x);
    CGFloat yDist = (point.y - referPoint.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    double pAngle = xDist == 0 ? GB_PI/2.f : atan(yDist/xDist);
    pAngle = (pAngle < 0) ? (GB_PI - fabs(pAngle)) : pAngle;
    double tAngle = fabs(pAngle) - fabs(angle);
    // 不在范围内
    if (tAngle > GB_PI/2.f || tAngle < 0.f || yDist < 0) {
        return nil;
    }
    
    double txDist = cos(tAngle) * distance;
    double tyDist = sin(tAngle) * distance;
    if (txDist > tranSize.width || tyDist > tranSize.height) {
        return nil;
    }
    
    // 判断坐标是否反转
    CGSize tempTSize;
    double tempTXDist = 0.f;
    double tempTYDist = 0.f;
    if (tranSize.width >= tranSize.height) {
        if (origSize.width >= origSize.height) {
            // 从左到右为进攻方向的映射
            tempTSize.width = tranSize.width;
            tempTSize.height = tranSize.height;
            tempTXDist = txDist;
            tempTYDist = tyDist;
            
        } else {
            // 从下到上为进攻方向的映射
            tempTSize.width = tranSize.height;
            tempTSize.height = tranSize.width;
            tempTXDist = tranSize.height - tyDist;
            tempTYDist = txDist;
        }
        
    } else {
        if (origSize.width >= origSize.height) {
            // 从左到右为进攻方向的映射
            tempTSize.width = tranSize.height;
            tempTSize.height = tranSize.width;
            tempTXDist = tyDist;
            tempTYDist = tranSize.width - txDist;
            
        } else {
            // 从下到上为进攻方向的映射
            tempTSize.width = tranSize.width;
            tempTSize.height = tranSize.height;
            tempTXDist = txDist;
            tempTYDist = tyDist;
        }
    }
    
    double rxDist = origSize.width / tempTSize.width * tempTXDist;
    double ryDist = origSize.height / tempTSize.height * tempTYDist;
    // 绘制坐标的原点在左上角
    ryDist = origSize.height - ryDist;
    
    if (tansX) {
        rxDist = origSize.width - rxDist;
    }
    
    if (transY) {
        ryDist = origSize.height - ryDist;
    }
    
    CGPoint rPoint = CGPointMake((int)floor(rxDist), (int)floor(ryDist));
    return [NSValue valueWithCGPoint:rPoint];
}

+ (NSArray<DailyInfo *> *)dailyInfoListWithDic:(NSDictionary *)dataDict {
    
    NSArray *itemArray = [dataDict allKeys];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    if (itemArray && [itemArray count] > 0) {
        for (int index = 0; index < [itemArray count]; index++) {
            NSString *key = itemArray[index];
            NSDictionary *itemDict = [dataDict objectForKey:key];
            
            [list addObject:[self parseDailyData:itemDict dateStr:key]];
        }
        return [list copy];
    }
    return nil;
}

+ (NSArray<DailyInfo *> *)dailySportInfoListWithDic:(NSDictionary *)dataDict {
    
    NSArray *itemArray = [dataDict allKeys];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    if (itemArray && [itemArray count] > 0) {
        for (int index = 0; index < [itemArray count]; index++) {
            NSString *key = itemArray[index];
            NSDictionary *itemDict = [dataDict objectForKey:key];
            
            [list addObject:[self parseDailySportData:itemDict dateStr:key]];
        }
        return [list copy];
    }
    return nil;
}

+ (void)asyncToday_DailyData {
    
    if ([RawCacheManager sharedRawCacheManager].isBindWristband && [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connected && [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal) {
        // [self.scrollView.mj_header endRefreshing];
        // [self showToastWithText:LS(@"daily.toast.read.error")];
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    
    //读取蓝牙
    [[GBBluetoothManager sharedGBBluetoothManager] readMutableCommonModelData:@[currentDate] level:GBBluetoothTask_PRIORITY_Low serviceBlock:^(id data, NSError *error) {
        
        if (!error) {
            //同步手环日常数据
            NSDictionary *dict = data;
            
            if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S && [RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail == 1) {
                [[GBBluetoothManager sharedGBBluetoothManager] readMutableSportStepData:@[currentDate] level:GBBluetoothTask_PRIORITY_Low serviceBlock:^(id data, NSError *error) {
                    NSDictionary *sportDict = data;
                    
                    NSData *parseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                    NSData *parseSportData = nil;
                    if (!error && sportDict && sportDict.allKeys.count > 0) {
                        parseSportData = [NSJSONSerialization dataWithJSONObject:sportDict options:0 error:nil];
                    }
                    [DailyRequest syncDailyData:parseData sportData:parseSportData handler:nil];
                }];
                
            } else if (!error && dict && dict.allKeys.count > 0) {
                NSData *parseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                [DailyRequest syncDailyData:parseData sportData:nil handler:nil];
            }
        }
        
    }];
}


+ (void)async7Day_DailyData {

    if ([RawCacheManager sharedRawCacheManager].isBindWristband && [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connected && [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal) {
        // [self.scrollView.mj_header endRefreshing];
        // [self showToastWithText:LS(@"daily.toast.read.error")];
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    //需要查询的手环日常数据的日期
    NSMutableArray *queryDateList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<=6; index++) {
        NSDate *date = [currentDate dateBySubtractingDays:index];
        [queryDateList addObject:date];
    }
    
    //读取蓝牙
    [[GBBluetoothManager sharedGBBluetoothManager] readMutableCommonModelData:queryDateList level:GBBluetoothTask_PRIORITY_Low serviceBlock:^(id data, NSError *error) {
        
        if (!error) {
            //同步手环日常数据
            NSDictionary *dict = data;
            
            if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S && [RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail == 1) {
                [[GBBluetoothManager sharedGBBluetoothManager] readMutableSportStepData:queryDateList level:GBBluetoothTask_PRIORITY_Low serviceBlock:^(id data, NSError *error) {
                    NSDictionary *sportDict = data;
                    
                    NSData *parseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                    NSData *parseSportData = nil;
                    if (!error && sportDict && sportDict.allKeys.count > 0) {
                        parseSportData = [NSJSONSerialization dataWithJSONObject:sportDict options:0 error:nil];
                    }
                    [DailyRequest syncDailyData:parseData sportData:parseSportData handler:nil];
                }];
                
            } else if (dict && dict.allKeys.count > 0) {
                NSData *parseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                [DailyRequest syncDailyData:parseData sportData:nil handler:nil];
            }
        }
        
    }];
}

+ (UIImage *)getImageWithHeadImage:(NSArray<UIImage *> *)headImages subviews:(NSArray<UIView *> *)subviews backgroundImage:(UIImage *)backgroundImage {
    
    NSMutableArray *arrImg = [NSMutableArray arrayWithCapacity:subviews.count];
    NSInteger scrHeight = 0;
    for (UIView *subView in subviews) {
        
        scrHeight += subView.height;
        UIGraphicsBeginImageContextWithOptions(subView.size, NO, 0);
        [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img4sub = UIGraphicsGetImageFromCurrentImageContext();
        if (nil == img4sub) {
            return nil;
        }
        UIGraphicsEndImageContext();
        [arrImg addObject:img4sub];
    }
    //头部图像高度
    for (UIImage *image in headImages) {
        scrHeight +=image.size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width,scrHeight), NO, 0);
    if (backgroundImage) {
        backgroundImage = [backgroundImage imageScaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,scrHeight)];
        [backgroundImage drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, scrHeight)];
    }
    
    CGFloat pointY = 0;
    for (UIImage *image in headImages) {
        [image drawAtPoint:CGPointMake(0, pointY)];
        pointY +=image.size.height;
    }
    for (NSInteger i = 0;i<[subviews count];i++) {
        UIImage *subimg = [arrImg objectAtIndex:i];
        UIView  *subview = [subviews objectAtIndex:i];
        [subimg drawAtPoint:CGPointMake(0, pointY)];
        pointY += subview.height;
    }
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

#pragma mark - Private

+ (DailyInfo *)parseDailyData:(NSDictionary *)dict dateStr:(NSString *)dateStr
{
    UserInfo *userObj = [RawCacheManager sharedRawCacheManager].userInfo;
    NSArray *parseData = [BluUtility calDaily:dict weight:userObj.weight height:userObj.height sex:(int)userObj.sexType];
    NSNumber *stepNum = parseData[0];
    NSNumber *distanceNum = parseData[1];
    NSNumber *consumeNum = parseData[2];
    
    DailyInfo *dailyObj = [[DailyInfo alloc] init];
    dailyObj.dailyStep = [stepNum intValue];
    dailyObj.dailyDistance = [distanceNum intValue];
    dailyObj.dailyConsume = [consumeNum doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    dailyObj.date = [date timeIntervalSince1970];
    
    return dailyObj;
}

+ (DailyInfo *)parseDailySportData:(NSDictionary *)dict dateStr:(NSString *)dateStr
{
    UserInfo *userObj = [RawCacheManager sharedRawCacheManager].userInfo;
    NSArray *parseData = [BluUtility calDailySport:dict weight:userObj.weight height:userObj.height sex:(int)userObj.sexType];
    
    DailyInfo *dailyObj = [[DailyInfo alloc] init];
    dailyObj.sportStep = [parseData[0] intValue];
    dailyObj.sportDistance = [parseData[1] floatValue];
    dailyObj.sportConsume = [parseData[2] floatValue];
    dailyObj.runStep = [parseData[3] intValue];
    dailyObj.runDistance = [parseData[4] floatValue];
    dailyObj.runConsume = [parseData[5] floatValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    dailyObj.date = [date timeIntervalSince1970];
    
    return dailyObj;
}

@end
