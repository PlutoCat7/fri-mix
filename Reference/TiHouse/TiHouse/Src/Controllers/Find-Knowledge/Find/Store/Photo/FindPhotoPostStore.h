//
//  FindPhotoPostStore.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindPhotoLabelModel.h"

@interface FindPhotoPostStore : NSObject

@property (nonatomic, strong) NSMutableArray<FindPhotoHandleModel *> *photoModelList;

- (instancetype)initWithWithPhotoModelList:(NSMutableArray<FindPhotoHandleModel *> *)list;

//上传图片
- (void)startUploadPhotoWithBlock:(void(^)(BOOL isSucess, BOOL finish))block;

//发布图文
- (void)postPhotoWithRichContent:(NSString *)content title:(NSString *)title activityId:(long)activityId completeBlock:(void(^)(BOOL isPost))completeBlock;

@end
