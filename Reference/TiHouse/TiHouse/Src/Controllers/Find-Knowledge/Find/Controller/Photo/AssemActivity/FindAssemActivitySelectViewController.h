//
//  FindAssemActivitySelectViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//  正在进行的征集选择

#import "FindKnowledgeBaseViewController.h"
#import "FindAssemActivityInfo.h"
@interface FindAssemActivitySelectViewController : FindKnowledgeBaseViewController

- (instancetype)initWithActivityInfo:(FindAssemActivityInfo *)activiInfo doneBlock:(void(^)(FindAssemActivityInfo *selectActivityInfo))doneBlock;

@end
