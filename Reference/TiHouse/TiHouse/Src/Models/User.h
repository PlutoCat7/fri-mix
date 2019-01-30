//
//  User.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying>

@property (readwrite, nonatomic, strong) NSString *mobile, *password, *username, *urlhead, *token ,*nickname;
@property (readwrite, nonatomic, assign) long registtime, birthdaytime, uid ,folderid ,uidconcert;
@property (readwrite, nonatomic, assign) int typerelation, countconcernuid, countconcernuidon, countassemarctype2, countassemarctype1;
@property (readwrite, nonatomic, strong) NSNumber *sex, *status;
@property (readwrite, nonatomic, assign) BOOL selected, isConcern;
@property (readwrite, nonatomic, copy) NSString *openidqq, *openidwechat, *openidweibo, *rongcloudToken;

@property (readwrite, nonatomic, assign) int userisreceiinte, userisvoice, userisshake, userisreceiknow;

@property (readwrite, nonatomic, assign) int useriswifi; // 是否只用wifi上传大文件
@property (readwrite, nonatomic, assign) int userisderive; // 是否是原生 1是2否

@end
