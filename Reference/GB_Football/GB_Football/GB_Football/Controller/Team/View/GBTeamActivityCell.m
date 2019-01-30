//
//  GBTeamActivityCell.m
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamActivityCell.h"

#import "UIImageView+WebCache.h"

@interface GBTeamActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation GBTeamActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)refreshWithTeamActivityInfo:(TeamActivityInfo *)teamActivityInfo {
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:teamActivityInfo.imageUrl]];
    self.titleLabel.text = teamActivityInfo.title;
    
    if (teamActivityInfo.endStatus == TeamActType_End) {
        [self.stateImageView setImage:[UIImage imageNamed:@"show_end.png"]];
    } else if (teamActivityInfo.endStatus == TeamActType_Doing) {
        [self.stateImageView setImage:[UIImage imageNamed:@"show_hot.png"]];
    }
}

@end
