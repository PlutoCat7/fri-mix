//
//  FindPhotoLabelTagViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@class FindPhotoLabelInfo;
@interface FindPhotoLabelTagViewController : FindKnowledgeBaseViewController

- (instancetype)initWithSelectStyleList:(NSArray<FindPhotoLabelInfo *> *)selectStyleList  doneBlock:(void(^)(NSArray<FindPhotoLabelInfo *> *selectStyleList))doneBlock;

@end
