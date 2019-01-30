//
//  PosterFavorTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterFavorTableViewCell.h"

@interface PosterFavorTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation PosterFavorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo {
    
    _knowModeInfo = knowModeInfo;
    
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:knowModeInfo.knowurlindex]];
    self.titleLabel.text = knowModeInfo.knowtitle;
}

- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

@end
