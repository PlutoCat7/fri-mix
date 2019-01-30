//
//  GBMallCell.h
//  GB_Football
//
//  Created by Pizza on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMallCell;
@protocol GBMallCellDelegate <NSObject>
@optional
- (void)GBMallCellDidSelect:(GBMallCell *)cell;
@end

@interface GBMallCell : UITableViewCell
// 添加按钮点击回调
@property (nonatomic,weak) id<GBMallCellDelegate> delegate;
- (void)refreshWithImageUrl:(NSString *)imageUrl;
@end
