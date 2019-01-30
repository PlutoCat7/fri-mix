//
//  SATitleTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SATitleTableViewCell.h"

@interface SATitleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation SATitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold {
    _knowModeInfo = knowModeInfo;
    
    if (_knowModeInfo.knowiscoll) {
        self.favorImageView.image = [UIImage imageNamed:@"klistfavor.png"];
    } else {
        self.favorImageView.image = [UIImage imageNamed:@"klistunfavor.png"];
    }
    self.titleLabel.text = _knowModeInfo.knowtitle;
    if (isFontBold) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
    
}
- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

- (IBAction)actionFavor:(id)sender {
    if (self.clickFavorBlock) {
        self.clickFavorBlock(_knowModeInfo);
    }
}

@end
