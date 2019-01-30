//
//  CloudRecordSearchCell.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CloudRecordSearchCellDelegate;
@interface CloudRecordSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) id<CloudRecordSearchCellDelegate>delegate;

@end

@protocol CloudRecordSearchCellDelegate <NSObject>

/**
 * 删除按钮事件
 * index 索引
 */
-(void)CloudRecordSearchCellDelegateCloseAction:(NSInteger )index;

@end
