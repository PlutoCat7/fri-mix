//
//  VideoRequest.h
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "VideoDetailInfo.h"

@interface VideoRequest : BaseNetworkRequest

+ (void)praiseVideo:(NSInteger)videoId isPraise:(BOOL)isPraise handler:(RequestCompleteHandler)handler;

+ (void)collectVideo:(NSInteger)videoId isCollect:(BOOL)isCollect handler:(RequestCompleteHandler)handler;

+ (void)commentVideo:(NSInteger)videoId content:(NSString *)content handler:(RequestCompleteHandler)handler;

+ (void)getVideoInfo:(NSInteger)videoId handler:(RequestCompleteHandler)handler;

//观看视频
+ (void)watchVideo:(NSInteger)videoId handler:(RequestCompleteHandler)handler;

@end
