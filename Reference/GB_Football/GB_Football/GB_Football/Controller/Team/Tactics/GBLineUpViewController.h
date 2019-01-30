//
//  GBTacticsViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "TeamHomeResponeInfo.h"

#import "GBLineUpViewModel.h"

@interface GBLineUpViewController : GBBaseViewController

/**
 创建 GBTacticsViewController

 @param teamHomeInfo 如果不传，则发起网络请求获取球队信息

 */
- (instancetype)initWithTeamInfo:(TeamHomeRespone *)teamHomeInfo useSelect:(BOOL)useSelect;

/**
 创建 GBTacticsViewController
 
 @param viewModel 如果不传，使用默认的
 */
- (instancetype)initWithTracticModel:(GBLineUpViewModel *)viewModel useSelect:(BOOL)useSelect;

- (void)loadLineUpList;

@end
