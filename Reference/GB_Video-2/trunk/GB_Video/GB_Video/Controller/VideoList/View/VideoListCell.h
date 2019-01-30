//
//  VideoListCell.h
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kVideoListCellHeight (240*kAppScale)

@class VideoListCellModel;
@class VideoListCell;
@protocol VideoListCellDelegate <NSObject>

- (void)playVideoWithCell:(VideoListCell *)cell;

- (void)praiseVideoWithCell:(VideoListCell *)cell;

- (void)collectVideoWithCell:(VideoListCell *)cell;

- (void)commentVideoWithCell:(VideoListCell *)cell;

@end

@interface VideoListCell : UITableViewCell

@property (nonatomic, weak) id<VideoListCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *playerContinerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void)refreshWithModel:(VideoListCellModel *)model;

@end
