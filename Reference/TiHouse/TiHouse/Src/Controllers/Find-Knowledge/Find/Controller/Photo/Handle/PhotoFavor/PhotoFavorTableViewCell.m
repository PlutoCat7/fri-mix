//
//  PhotoFavorTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PhotoFavorTableViewCell.h"

@interface PhotoFavorTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) SoulFolderInfo *soulFolderInfo;
@end

@implementation PhotoFavorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithSoulFolder:(SoulFolderInfo *)soulFolderInfo {
    _soulFolderInfo = soulFolderInfo;
    
    self.titleLabel.text = soulFolderInfo.soulfoldername;
    self.countLabel.text = [NSString stringWithFormat:@"%td", soulFolderInfo.allcount];
}

@end
