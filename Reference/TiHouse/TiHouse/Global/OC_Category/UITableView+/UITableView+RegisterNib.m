//
//  UITableView+RegisterNib.m
//  bbd
//
//  Created by apple on 2017/10/13.
//  Copyright © 2017年 baichuanxin. All rights reserved.
//

#import "UITableView+RegisterNib.h"

@implementation UITableView (RegisterNib)


/**
 id 与nibName一致
 
 @param name nibName
 */
- (void)registerNibName:(NSString *)name{
    
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    
    [self registerNib:nib forCellReuseIdentifier:name];

}

@end
