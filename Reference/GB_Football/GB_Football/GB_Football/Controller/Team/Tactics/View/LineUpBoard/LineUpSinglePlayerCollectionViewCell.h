//
//  TracticsSinglePlayerCollectionViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAvatorView.h"

@class LineUpSinglePlayerCollectionViewCell;
@protocol LineUpSinglePlayerCollectionViewCellDelegate <NSObject>

- (void)didClickDeleteBtn:(LineUpSinglePlayerCollectionViewCell *)cell;

@end

@interface LineUpSinglePlayerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (nonatomic, assign) BOOL hasSelected;
@property (nonatomic, assign) BOOL showDeleteIcon;

@property (nonatomic, weak) id<LineUpSinglePlayerCollectionViewCellDelegate> delegate;

@end
