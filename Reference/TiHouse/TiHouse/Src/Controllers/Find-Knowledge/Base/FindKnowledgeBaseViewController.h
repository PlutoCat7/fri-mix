//
//  FindBaseViewController.h
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface FindKnowledgeBaseViewController : BaseViewController

#pragma mark - 子类可重写

/** 加载数据 */
- (void)loadData;

/** UI创建 */
- (void)setupUI;

/** 网络 */
- (void)loadNetworkData;

@end
