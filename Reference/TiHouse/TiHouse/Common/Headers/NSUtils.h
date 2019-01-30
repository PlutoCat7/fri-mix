//
//  NSUtils.h
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#ifndef NSUtils_h
#define NSUtils_h

#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define RGB(r, g, b) RGBA(r, g, b, 1)
///已完成标题文本颜色
#define kdayListPastTextColor RGB(191, 191, 191)
///未完成标题文本颜色
#define kdayListFutureTextColor RGB(0, 0, 0)

///已完成文本颜色
#define kdayTypeFinishTextColor RGB(191, 191, 191)
///未完成完成文本颜色
#define kdayTypeExeTextColor RGB(68, 68, 75)
///已完成背景颜色
#define kdayTypeFinishBGColor RGB(248, 248, 248)
///未完成完成背景颜色
#define kdayTypeExeBGColor RGB(253, 240, 134)

//#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate


/**
 判断字段时候为空的情况
 @param x 字段名称
 */
#define IF_NULL_TO_STRING(x,normalMsg) ([(x) isEqual:[NSNull null]]||(x)==nil)? normalMsg:x

//错误信息提示判断
#define IF_NULL_TO_STRINGSTR(x,normalMsg) ([(x) isEqual:[NSNull null]]||(x)==nil || [(x) isEqualToString:@""])? normalMsg:x

#define IMAGE_ANME(name)  [UIImage imageNamed:name]

#define WS(weakSelf) __weak typeof(self) weakSelf = self

#define JLocalString(string) NSLocalizedString(string, @"")
#define JInitMutableArray [[NSMutableArray alloc] init]
#define JInitMutableDictionary [[NSMutableDictionary alloc] init]
#define JInt2String(int) [NSString stringWithFormat:@"%i",int]
#define JLong2String(long) [NSString stringWithFormat:@"%ld",long]
#define JFloat2String(float) [NSString stringWithFormat:@"%f",float]
#define JString(string, ...) [NSString stringWithFormat:string,## __VA_ARGS__]



#endif /* NSUtils_h */
