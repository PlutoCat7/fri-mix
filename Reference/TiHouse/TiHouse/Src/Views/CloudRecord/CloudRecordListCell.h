//
//  CloudRecordListCell.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloudRecordListCellDelegate;
@interface CloudRecordListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelConstraintY;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) id<CloudRecordListCellDelegate>delegate;

@end

@protocol CloudRecordListCellDelegate <NSObject>

/**
 * 删除按钮事件
 * index 索引
 */
-(void)CloudRecordListCellDelegateDelAction:(NSInteger )index;

@end
