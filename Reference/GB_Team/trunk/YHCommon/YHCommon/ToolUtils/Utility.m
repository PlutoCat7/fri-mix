//
//  Utility.m
//  GB_Football
//
//  Created by weilai on 16/2/18.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "Utility.h"

#define LS(key) NSLocalizedString(key, nil)

@implementation Utility

NSError *makeError(NSInteger errorCode, NSString *description)
{
    NSString *desc = description;
    if (desc == nil) {
        desc = LS(@"ErrorDefault");
    }
    
    return [[NSError alloc] initWithDomain:desc code:errorCode userInfo:nil];
}

+ (ScreenSizeMode)getScreenSizeMode
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger screenHeight = screenSize.size.height;
    if (screenHeight == 480)
    {
        return ScreenSizeMode_35;
    }
    else if (screenHeight == 568)
    {
        return ScreenSizeMode_40;
    }
    else if (screenHeight == 667)
    {
        return ScreenSizeMode_47;
    }
    else if (screenHeight == 736)
    {
        return ScreenSizeMode_55;
    }
    else if (screenHeight == 1024)
    {
        return ScreenSizeMode_97;
    }
    return ScreenSizeMode_35;
}
//版本
+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSString *name = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

// 版本号
+ (NSInteger)appVersionCode
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return build ? [build integerValue] : 0;
}

// 包名
+ (NSString *)appBundleIdentifier
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    return bundleIdentifier;
}

// 计算年龄
+ (NSString*)fromDateToAge:(NSDate*)date
{

    NSDate *myDate = date;
    NSDate *nowDate = [NSDate date];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    NSInteger year = [comps year];
    
    return [NSString stringWithFormat:@"%lu", (long)year];
}

+ (BOOL)createFolderWithFolder:(NSString *)folder
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *parentFolder = [folder stringByDeletingLastPathComponent];
    BOOL isDir = YES;
    BOOL isExists = [fileManager fileExistsAtPath:folder isDirectory:&isDir];
    if (isExists && isDir)
    {
        return YES;
    }
    if (![parentFolder isEqualToString:@"/"] && ![fileManager fileExistsAtPath:parentFolder])
    {
        if (![Utility createFolderWithFolder:parentFolder])
        {
            return NO;
        };
    }
    if (![fileManager fileExistsAtPath:folder])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            return NO;
        }
    }
    return YES;
}


//Dictionary转string
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [Utility jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"%@:%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [Utility jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [Utility jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [Utility jsonStringWithArray:object];
    }
    return value;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",
            [string stringByReplacingOccurrencesOfString:@"\n" withString:@""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [Utility jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

// 计算星期几
+ (NSString *)weekFromDate:(long)dateValue
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    switch (weekDay) {
        case 2:
            return LS(@"星期一");
            
        case 3:
            return LS(@"星期二");
            
        case 4:
            return LS(@"星期三");
            
        case 5:
            return LS(@"星期四");
            
        case 6:
            return LS(@"星期五");
            
        case 7:
            return LS(@"星期六");
            
        case 1:
            return LS(@"星期天");
            
        default:
            break;
    }
    
    return @"";
    
}

// 获取当月的天数
+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

+ (NSString *)float2NSString:(float)value
{
    if (value>=0.1) {
        return [NSString stringWithFormat:@"%.1f", value];
        
    } else if (value<0.1 && value>=0.01) {
        return [NSString stringWithFormat:@"%.2f", value];
    } else {
        return @"0";
    }
}

+ (UIViewController *)findController:(UINavigationController *)nvc class:(Class)class
{
    __block UIViewController *retController = nil;
    if (nvc)
    {
        [nvc.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj isKindOfClass:class])
             {
                 retController = obj;
                 *stop = YES;
             }
         }];
    }
    return retController;
}

@end
