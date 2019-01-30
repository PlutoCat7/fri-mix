//
//  SplashResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2016/12/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  闪屏广告

#import "GBResponseInfo.h"

@interface SplashInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) PushType type;
@property (nonatomic, copy) NSString *param_url;    //网页地址
@property (nonatomic, copy) NSString *param_uri;  //打开三方app地址
@property (nonatomic, assign) NSInteger param_id;
@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end

@interface SplashResponseInfo : GBResponseInfo

@property (nonatomic, strong) SplashInfo *data;

@end
