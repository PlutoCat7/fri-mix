//
//  AddTallyViewTextCell.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTallyViewTextCellDelegate<AddTallyViewCellProtocol>

- (void)addTallyViewTextCell:(UITableViewCell *)cell textViewDidChange:(NSString *)text;

@end

@interface AddTallyViewTextCell : UITableViewCell
@property (weak, nonatomic)  UIImageView *iconImageView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *text;
@property (weak, nonatomic) id<AddTallyViewTextCellDelegate> delegate;
@property (assign, nonatomic) BOOL isFromVoice; // 内容来自语音输入
@property (assign, nonatomic) BOOL disabled;
@end

@interface UITableView (AddTallyViewTextCell)

- (AddTallyViewTextCell *)addTallyViewTextCellWithId:(NSString *)cellId;

@end
