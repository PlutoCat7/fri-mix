//
//  GBAddressCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/16.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBAddressCell;
@protocol GBAddressCellDelegate <NSObject>
@optional
- (void)GBAddressCell:(GBAddressCell *)cell;
@end

@interface GBAddressCell : UITableViewCell

// 是否是section中的最后一row，用于处理分割线问题
@property (assign,nonatomic)BOOL isLastCell;
// 添加按钮点击回调
@property (nonatomic, weak) id<GBAddressCellDelegate> delegate;

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
