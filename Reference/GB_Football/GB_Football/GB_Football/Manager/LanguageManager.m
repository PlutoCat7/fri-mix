//
//  LanguageManager.m
//  GB_Football
//
//  Created by gxd on 16/10/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LanguageManager.h"

#import "GDataXMLNode.h"

static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageItem

- (LanguageItemType)languageType {
    
    switch (self.langId) {
        case 0:
            return LanguageItemType_Hans;
            break;
        case 1:
            return LanguageItemType_English;
            break;
        case 2:
            return LanguageItemType_Hant;
            break;
            
        default:
            return LanguageItemType_Hans;
            break;
    }
}

@end


@interface LanguageManager ()

@property (nonatomic, strong) NSArray<LanguageItem *> *languageList;

@end

@implementation LanguageManager

+ (RawCacheManager *)sharedLanguageManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[LanguageManager alloc] init];
    });
    return instance;
}

- (NSArray<LanguageItem *> *)languageList {
    
    if (!_languageList) {
        
        // 读取language.xml文件
        NSMutableArray *tmpList = [[NSMutableArray alloc] initWithCapacity:1];
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"language" ofType:@"xml"];
        NSData *data=[[NSData alloc]initWithContentsOfFile:filepath];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding error:nil];
        GDataXMLElement *xmlEle = [xmlDoc rootElement];
        NSArray *array = [xmlEle children];
        //读取省
        for (int i = 0; i < [array count]; i++) {
            GDataXMLElement *ele = [array objectAtIndex:i];
            // 根据标签名判断
            if ([[ele name] isEqualToString:@"language"]) {
                LanguageItem *languageObj = [[LanguageItem alloc]init];
                languageObj.langId = [[[ele attributeForName:@"id"] stringValue] integerValue];
                languageObj.langPrefix = [[ele attributeForName:@"prefix"] stringValue];
                languageObj.langName = [[ele attributeForName:@"name"] stringValue];
                
                
                [tmpList addObject:languageObj];
            }
        }
        _languageList = [tmpList copy];
    }
    return _languageList;
}

- (void)setupCurrentLanguage {
    
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    if (!currentLanguage) {
        LanguageItem *item = [LanguageManager sharedLanguageManager].getCurrentAppLanguage;
        currentLanguage = item.langPrefix;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    [NSBundle setLanguage:currentLanguage];
}

- (void)saveLanguageItem:(LanguageItem *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language.langPrefix forKey:LanguageSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@[language.langPrefix] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSBundle setLanguage:language.langPrefix];
}

// 获取当前语言
- (LanguageItem *)getCurrentAppLanguage {
    NSString *language = [UIDevice systemLanguage];
    
    LanguageItem *curLanguage = nil;
    for (LanguageItem *languageItem in self.languageList) {
        if ([[language lowercaseString] hasPrefix:[languageItem.langPrefix lowercaseString]]) {
            curLanguage = languageItem;
            break;
        }
    }
    
    // 默认时英文
    if (curLanguage == nil && [self.languageList count] > 2) {
        curLanguage = self.languageList[2];
    }
    
    return curLanguage;
}

// 当前语言是否是英文系
- (BOOL)isEnglish
{
    LanguageItem *item = [LanguageManager sharedLanguageManager].getCurrentAppLanguage;
    if ([item.langPrefix hasPrefix:@"en"] == YES)return YES;
    return NO;
}
@end
