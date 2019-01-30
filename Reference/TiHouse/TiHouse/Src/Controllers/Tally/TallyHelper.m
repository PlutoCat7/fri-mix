//
//  TallyHelper.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyHelper.h"

@interface TallyHelper()

@end

@implementation TallyHelper

+ (CGSize)labelSize:(NSString *)contentStr font:(UIFont *)font height:(CGFloat)height {
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}


+ (BOOL)isContainDeteStr:(NSString *)str {
    NSString *datePattern = @"([1-9]|1[0-2])月((0?[1-9])|((1|2)[0-9])|30|31)(日|号)";
    NSRegularExpression *exp =
    [[NSRegularExpression alloc] initWithPattern:datePattern
                                         options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                           error:nil];
    NSArray *result = [exp matchesInString:str
                                   options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                     range:NSMakeRange(0, str.length)];
    return result.count > 0;
}

+ (NSString *)getTimeNowWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *today = [NSDate date]; //当前时间
    return [dateFormatter stringFromDate:today];
}

+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSString *)formatTime:(NSTimeInterval)timestamp formatWith:(NSString *)format {
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    if (time == 0) {
        return @"";
    } else {
        return [self formatDate:time formatWith:format];
    }
}

+ (NSDate *)currentDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    //calendar是基于当前时区的，date是GMT，comps是返回date+8的当前时区的时间
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear |
                                                    NSCalendarUnitMonth |
                                                    NSCalendarUnitDay |
                                                    NSCalendarUnitHour |
                                                    NSCalendarUnitMinute |
                                                    NSCalendarUnitSecond)
                                          fromDate:date];
    comps.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    date = [calendar dateFromComponents:comps];
    return date;
}

@end

