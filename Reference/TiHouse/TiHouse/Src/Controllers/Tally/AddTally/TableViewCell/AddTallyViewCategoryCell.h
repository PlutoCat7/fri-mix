//
//  AddTallyViewCategoryCell.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TallyCategoryView.h"
@protocol AddTallyViewCategoryCellDelegate<AddTallyViewCellProtocol>

- (void)addTallyViewCategoryCellAddProjectAction:(UITableViewCell *)cell catetwoid:(NSInteger)catetwoid;
- (void)addTallyViewCategoryCellSelected:(UITableViewCell *)cell categoryStr:(NSString *)categoryStr;
@end

@interface AddTallyViewCategoryCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<AddTallyViewCategoryCellDelegate> delegate;
@property (strong, nonatomic) NSArray<TallyCategory *> *data;

@property (strong, nonatomic, readonly) TallyCategory *category1;
@property (strong, nonatomic, readonly) TallySecondCategoryModel *category2;
@property (strong, nonatomic, readonly) TallyThridCategoryModel *category3;
@property (assign, nonatomic) BOOL disabled;

- (void)setCategoryId:(NSInteger)cateoneid catetwoid:(NSInteger)catetwoid catethreeid:(NSInteger)catethreeid;
@end

@interface UITableView (AddTallyViewCategoryCell)

- (AddTallyViewCategoryCell *)addTallyViewCategoryCellWithId:(NSString *)cellId;

@end
