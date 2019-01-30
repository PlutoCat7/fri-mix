//
//  AddTallyViewDateSynchroCell.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddTallyViewDateSynchroCellDelegate<AddTallyViewCellProtocol>

- (void)addTallyViewDateSynchroCellTimeSynchro:(UITableViewCell *)cell;

@end

@interface AddTallyViewDateSynchroCell : UITableViewCell
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL disabled;

@property (weak, nonatomic) id<AddTallyViewDateSynchroCellDelegate> delegate;

- (void)setCellInfo:(BOOL)containDeteStr;

@end

@interface UITableView (AddTallyViewDateSynchroCell)

- (AddTallyViewDateSynchroCell *)addTallyViewDateSynchroCellWithId:(NSString *)cellId;

@end
