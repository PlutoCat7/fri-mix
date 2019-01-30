//
//  ModelLabelRequest.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "FindPhotoLabelResponse.h"
#import "FindPhotoThingResponse.h"
#import "FindPhotoStyleResponse.h"
#import "SoulFolderResponse.h"

@interface ModelLabelRequest : BaseNetworkRequest

//获取所有标签
+ (void)getModelLabelListWithHandler:(RequestCompleteHandler)handler;

//获取所有物品
+ (void)getModelThingListWithHandler:(RequestCompleteHandler)handler;
+ (void)getModelBrandListWithHandler:(NSString *)key handler:(RequestCompleteHandler)handler;

//获取所有风格
+ (void)getModelStyleListWithHandler:(RequestCompleteHandler)handler;

//获取灵感相册
+ (void)getSoulFolderWithHandler:(RequestCompleteHandler)handler;
//添加灵感相册
+ (void)addSoulFolderWithName:(NSString *)folderName handler:(RequestCompleteHandler)handler;

@end
