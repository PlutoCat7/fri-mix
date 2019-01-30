//
//  PosterMSubTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterMSubTableViewCell.h"

@interface PosterMSubTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation PosterMSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold {
    
    _knowModeInfo = knowModeInfo;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:knowModeInfo.knowurlindex]];
    self.titleLabel.text = knowModeInfo.knowtitle;
    self.contentLabel.text = knowModeInfo.knowtitlesub;
    if (isFontBold) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
}

- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

@end
