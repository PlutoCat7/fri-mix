//
//  AssemDetailViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindAssemActivityInfo.h"

@interface AssemDetailViewController : FindKnowledgeBaseViewController

@property (nonatomic, assign) CGFloat viewHeight;

- (instancetype)initWithAssemInfo:(FindAssemActivityInfo *)info;

- (void)refreshWithAssemInfo:(FindAssemActivityInfo *)info;

@end
