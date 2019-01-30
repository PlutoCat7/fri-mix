//
//  LanguageManager.h
//  GB_Football
//
//  Created by gxd on 16/10/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LanguageItemType) {
    LanguageItemType_Hans,  //简体
    LanguageItemType_English, //英文
    LanguageItemType_Hant,  //繁体
};

@interface LanguageItem : NSObject

@property (nonatomic, assign) NSInteger langId;
@property (nonatomic, copy) NSString *langPrefix;
@property (nonatomic, copy) NSString *langName;

@property (nonatomic, assign, readonly) LanguageItemType languageType;

@end

@interface LanguageManager : NSObject

+ (LanguageManager *)sharedLanguageManager;


@property (nonatomic, strong, readonly) NSArray<LanguageItem *> *languageList;

- (void)setupCurrentLanguage;
- (void)saveLanguageItem:(LanguageItem *)language;
// 获取当前语言
- (LanguageItem *) getCurrentAppLanguage;

// 当前语言是否为英语系
- (BOOL)isEnglish;

@end
