//
//  FindWaterfallViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@interface FindWaterfallViewController : FindKnowledgeBaseViewController

- (instancetype)initWithSearchName:(NSString *)searchName;

//搜索名称
- (void)reSearchWithName:(NSString *)name;

@end
