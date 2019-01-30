//
//  AaddTallyViewTextCell.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddTallyViewGeneralCellDelegate<AddTallyViewCellProtocol>

- (void)showImagesBrower;
- (void)addImage;

@end

@interface AddTallyViewGeneralCell : UITableViewCell
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, weak) NSIndexPath *indexPath;

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UIImageView *menu_arrow;
@property (weak, nonatomic) UIView *imgsContainer;

@property(weak, nonatomic) id<AddTallyViewGeneralCellDelegate> delegate;
@property (assign, nonatomic) BOOL activate;
@property (assign, nonatomic) BOOL disabled;


- (void)setCellTextInfo:(NSString *)imageName title:(NSString *)text;

- (void)setCellImagesInfo:(NSArray *)imgs showAdd:(BOOL)show;

@end

@interface UITableView (AddTallyViewGeneralCell)

- (AddTallyViewGeneralCell *)addTallyViewGeneralCellWithId:(NSString *)cellId;

@end
