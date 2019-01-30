//
//  FindPhotoLabelStyleViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@class FindPhotoStyleInfo;
@interface FindPhotoLabelStyleViewController : FindKnowledgeBaseViewController

- (instancetype)initWithSelectStyleList:(NSArray<FindPhotoStyleInfo *> *)selectStyleList  doneBlock:(void(^)(NSArray<FindPhotoStyleInfo *> *selectStyleList))doneBlock;

@end
