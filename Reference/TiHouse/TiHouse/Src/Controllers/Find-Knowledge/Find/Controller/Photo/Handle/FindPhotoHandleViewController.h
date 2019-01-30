//
//  FindPhotoHandleViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindPhotoLabelModel.h"
@class HXPhotoModel;
@interface FindPhotoHandleViewController : FindKnowledgeBaseViewController

- (instancetype)initWithPhotoList:(NSArray<HXPhotoModel *> *)photoList doneBlock:(void(^)(NSArray<FindPhotoHandleModel *> *photoModelList))doneBlock;

@end
