//
//  GBMessageViewController.h
//  GB_Football
//
//  Created by Pizza on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PageViewController.h"

@interface GBMessageViewController : PageViewController

@property (nonatomic, copy) void(^didRefreshMessage)();

@end
