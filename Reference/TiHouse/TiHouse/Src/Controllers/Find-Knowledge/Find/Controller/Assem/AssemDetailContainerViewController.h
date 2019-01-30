//
//  AssemDetailContainerViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindAssemActivityInfo.h"

@interface AssemDetailContainerViewController : FindKnowledgeBaseViewController

- (instancetype)initWithAssemInfo:(FindAssemActivityInfo *)info;

- (instancetype)initWithAssemId:(long)assemId;

@end
