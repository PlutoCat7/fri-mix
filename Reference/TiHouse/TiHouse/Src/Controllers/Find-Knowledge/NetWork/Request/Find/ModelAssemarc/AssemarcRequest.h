//
//  AssemarcRequest.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "GBResponseInfo.h"

@interface AssemarcRequest : BaseNetworkRequest

/**
 发布文章

 @param assemarctitle 标题
 @param urlindex 封面url
 @param assemarccontent 内容（html）
 */
+ (void)postArticleWithAssemarctitle:(NSString *)assemarctitle
                            urlindex:(NSString *)urlindex
                     assemarccontent:(NSString *)assemarccontent
                             handler:(RequestCompleteHandler)handler;
/**
 发布套图

 @param assemid 活动id，没有则不传
 @param assemarctitle 套图描述
 @param assemarcfileJAstr 套图的图片，JSONArray数组格式的字符串，格式如下
 */
+ (void)postPhotosWithAssemid:(long)assemid
                  assemarctitle:(NSString *)assemarctitle
               assemarcfileJAstr:(NSString *)assemarcfileJAstr
                        handler:(RequestCompleteHandler)handler;

//添加征集图文收藏
+ (void)addAssemarcFavor:(NSInteger)assemarcId handler:(RequestCompleteHandler)handler;
//取消征集图文收藏
+ (void)removeAssemarcFavor:(NSInteger)assemarcId handler:(RequestCompleteHandler)handler;

//添加征集图文点赞
+ (void)addAssemarcZan:(NSInteger)assemarcid handler:(RequestCompleteHandler)handler;
//取消征集图文点赞
+ (void)removeAssemarcZan:(NSInteger)assemarcid handler:(RequestCompleteHandler)handler;

//添加关注
+ (void)addAttentionWithConcernuidon:(NSInteger)concernuidon handler:(RequestCompleteHandler)handler;
//取消关注
+ (void)removeAttentionWithConcernuidon:(NSInteger)concernuidon handler:(RequestCompleteHandler)handler;

// 添加单图收藏
+ (void)addSinglePhotoFavor:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler;
// 取消单图收藏
+ (void)removeSinglePhotoFavor:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler;
// 移动相册
+ (void)moveToSoulFolder:(NSInteger)assemarcfileid soulFolderId:(NSInteger)soulFolderId handler:(RequestCompleteHandler)handler;

// 添加下载数
+ (void)addDownloadCount:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler;


@end
