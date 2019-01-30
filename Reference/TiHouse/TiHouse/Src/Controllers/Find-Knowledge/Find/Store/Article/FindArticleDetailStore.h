//
//  FindArticleDetailStore.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FindAssemarcInfo;
@interface FindArticleDetailStore : NSObject

@property (nonatomic, strong) FindAssemarcInfo *arcInfo;

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo;

//点赞
- (void)likeArticleWithHandler:(void(^)(BOOL isSuccess))handler;
//收藏
- (void)favorArticleWithHandler:(void(^)(BOOL isSuccess))handler;

//关注
- (void)attentionWithHandler:(void(^)(BOOL isSuccess))handler;

@end
