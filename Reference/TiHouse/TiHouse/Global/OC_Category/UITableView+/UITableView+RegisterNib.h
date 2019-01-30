//
//  UITableView+RegisterNib.h
//  bbd
//
//  Created by apple on 2017/10/13.
//  Copyright © 2017年 baichuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RegisterNib)


/**
 id 与nibName一致

 @param name nibName
 */
- (void)registerNibName:(NSString *)name;

@end
