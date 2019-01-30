//
//  VideoListCell.m
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoListCell.h"
#import "UIImageView+WebCache.h"

#import "VideoListCellModel.h"

@interface VideoListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoDefaultImageView;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithModel:(VideoListCellModel *)model {
    
    [self.videoDefaultImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.videoNameLabel.text = model.videoName;
    self.watchCountLabel.text = [NSString stringWithFormat:@"播放数 : %td", model.watchCount];
    self.praiseButton.selected = model.isPraise;
    self.collectionButton.selected = model.isCollection;
}

- (IBAction)actionPlay:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(playVideoWithCell:)]) {
        [_delegate playVideoWithCell:self];
    }
}
- (IBAction)actionComment:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(commentVideoWithCell:)]) {
        [_delegate commentVideoWithCell:self];
    }
}
- (IBAction)actionCollecte:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(collectVideoWithCell:)]) {
        [_delegate collectVideoWithCell:self];
    }
}
- (IBAction)actionPraise:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(praiseVideoWithCell:)]) {
        [_delegate praiseVideoWithCell:self];
    }
}

@end
