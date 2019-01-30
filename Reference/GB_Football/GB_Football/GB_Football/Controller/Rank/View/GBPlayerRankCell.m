//
//  GBPlayerRankCell.m
//  GB_Football
//
//  Created by gxd on 2017/11/30.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPlayerRankCell.h"
#import "UIImageView+WebCache.h"

@interface GBPlayerRankCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
    
@end

@implementation GBPlayerRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.playerImageView.clipsToBounds = YES;
    [self.playerImageView.layer setCornerRadius:self.playerImageView.width/2];
    [self.playerImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
    
- (void)initWithPlayerRankInfo:(PlayerRankInfo *)playerRankInfo type:(PlayerRank)type index:(NSInteger)index {
    if (index == 0) {
        self.bgView.backgroundColor = [UIColor colorWithHex:0x202022];
        self.rankImageView.hidden = NO;
        self.rankImageView.image = [UIImage imageNamed:@"gold"];
        self.rankLabel.hidden = YES;
        
    } else if (index == 1) {
        self.bgView.backgroundColor = [UIColor colorWithHex:0x202022];
        self.rankImageView.hidden = NO;
        self.rankImageView.image = [UIImage imageNamed:@"silver"];
        self.rankLabel.hidden = YES;
        
    } else if (index == 2) {
        self.bgView.backgroundColor = [UIColor colorWithHex:0x202022];
        self.rankImageView.hidden = NO;
        self.rankImageView.image = [UIImage imageNamed:@"copper"];
        self.rankLabel.hidden = YES;
        
    } else {
        self.bgView.backgroundColor = [UIColor colorWithHex:0x0e0e0d];
        self.rankImageView.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%td", (index + 1)];
    }
    
    [self.playerImageView sd_setImageWithURL:[NSURL URLWithString:playerRankInfo.photoImageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.nameLabel.text = playerRankInfo.nickName;
    if (type == PlayerRank_Score) {
        self.valueLabel.text = [NSString stringWithFormat:@"%d", (int) playerRankInfo.value];
    } else {
        self.valueLabel.text = [NSString stringWithFormat:@"%0.1f", playerRankInfo.value];
    }
}

@end
