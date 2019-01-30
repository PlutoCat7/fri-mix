//
//  Utility.h
//  GB_Football
//
//  Created by weilai on 16/2/18.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    ScreenSizeMode_35 = 0,    //3.5英寸
    ScreenSizeMode_40,        //4英寸
    ScreenSizeMode_47,        //4.7英寸
    ScreenSizeMode_55,        //5.5英寸
    ScreenSizeMode_97         //9.7英寸
} ScreenSizeMode;

@interface Utility : NSObject

extern NSError *makeError(NSInteger errorCode, NSString *description);

+ (ScreenSizeMode)getScreenSizeMode;

// 计算年龄
+ (NSString*)fromDateToAge:(NSDate*)date;

+ (NSString *)appVersion;
+ (NSInteger)appVersionCode;
+ (NSString *)appBundleIdentifier;
// 创建文件
+ (BOOL)createFolderWithFolder:(NSString *)folder;

//Dictionary转string
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

// 计算星期几
+ (NSString *)weekFromDate:(long)dateValue;

// 获取当月的天数
+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date;

// 坐标转换
+ (NSArray *)transformPointArray:(NSArray *)fourPoints origPoints:(NSArray *)origPoints size:(CGSize)size tansX:(BOOL)tansX tansY:(BOOL)transY;

// float转NSString最多保留两位小数
+ (NSString *)float2NSString:(float)value;

+ (UIViewController *)findController:(UINavigationController *)nvc class:(Class)class;

@end
