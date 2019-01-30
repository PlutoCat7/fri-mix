//
//  ShopResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface ShopItemInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, copy) NSString *param_url;    //网页地址
@property (nonatomic, copy) NSString *param_uri;  //打开三方app地址
@property (nonatomic, assign) NSInteger param_id;
@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end

@interface ShopInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<ShopItemInfo *> *banner;
@property (nonatomic, strong) NSArray<ShopItemInfo *> *list;

@end

@interface ShopResponseInfo : GBResponseInfo

@property (nonatomic, strong) ShopInfo *data;

@end
