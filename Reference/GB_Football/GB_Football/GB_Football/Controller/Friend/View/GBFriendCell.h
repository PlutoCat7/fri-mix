//
//  GBFriendCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBFriendCell : UITableViewCell

// 是否是section中的最后一row，用于处理分割线问题
@property (assign,nonatomic)BOOL isLastCell;

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
