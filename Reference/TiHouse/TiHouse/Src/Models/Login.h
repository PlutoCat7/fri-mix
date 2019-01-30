//
//  Login.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef  NS_ENUM(NSInteger ,GoToPathType){
    GoToPathTypeLogin = 1,
    GoToPathTypeRegister,
    GoToPathTypeWechat,
    GoToPathTypeWeibo,
    GoToPathTypeQQ,
    GoToPathTypeRegisterSMS,
};

@interface Login : NSObject

@property (nonatomic, readwrite, strong) NSString *phone, *password, *messageCode, *nickname, *urlhead, *openid, *code, *access_token;
@property (nonatomic, assign) GoToPathType goToPath;
@property (nonatomic, assign) BOOL isOpenIDOAuth, isGetUserIf;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, copy) NSString *picturecodevalue;
@property (nonatomic, assign) long picturecodeid;



- (NSString *)toPath;
- (NSMutableDictionary *)toParams;
- (NSString *)toMessagePath;
- (NSDictionary *)toMessageParams;

+ (BOOL)refreshLoginData:(NSDictionary *)loginData;
+ (User *)curLoginUser;
+ (long)curLoginUserID;
+ (void)doLogout;
+ (BOOL)isLogin;
+ (void)doLogin:(NSDictionary *)loginData;
+ (NSMutableDictionary *)readLoginDataList;
+ (BOOL)saveLoginData:(NSDictionary *)loginData;
+ (NSString *)loginDataListPath;
+(BOOL)isFirst;

@end
