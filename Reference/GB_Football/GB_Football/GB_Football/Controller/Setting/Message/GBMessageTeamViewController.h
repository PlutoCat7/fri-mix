//
//  GBMessageTeamViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PageViewController.h"

@interface GBMessageTeamViewController : PageViewController

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) void(^deleteMessageBlock)(NSArray *deleteList);
@property (nonatomic, copy) void(^didRefreshMessage)();

- (void)removeMessageWithList:(NSArray *)list;

@end
