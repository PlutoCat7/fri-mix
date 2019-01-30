//
//  UIHelp.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelp : NSObject

+(NSArray *)getAddHouseUI;
+(NSArray *)getRelationUIWithHousename:(NSString *)housename;
+(NSArray *)getHouseChangeUI;
+(NSArray *)getRecordingTimeUI;
+(NSArray *)getFriendsRange;
+(NSArray *)getNewBudgerUI;
+(NSArray *)getSettingsUI;
+(NSArray *)getAccountInfoUI;
+(NSArray *)getAboutUSUI;
+(NSArray *)getClearCacheUI;
+(NSArray *)getNotificationUI;
+(NSArray *)getCoverImages;
@end

@interface UIModel : NSObject

@property (nonatomic, copy) NSString *TextFieldPlaceholder;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Icon;


-(instancetype)initWithTitleStr:(NSString *)title TextFieldPlaceholder:(NSString *)placeholder Icon:(NSString *)icon;
-(instancetype)initWithTitleStr:(NSString *)title TextFieldPlaceholder:(NSString *)placeholder;
-(instancetype)initWithTitleStr:(NSString *)title;
@end

