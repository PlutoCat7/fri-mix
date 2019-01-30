//
//  GBTeamHomeCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamHomeCell.h"

@interface GBTeamHomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticNUmberLabel;

@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end

@implementation GBTeamHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self localizeUI];
    self.avatorView.bgColor = [UIColor colorWithHex:0x252525];

}

- (void)localizeUI {
    
    self.staticLabel.text = LS(@"full.label.positon");
    self.staticNUmberLabel.text = LS(@"team.home.jersey");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.typeView.layer.cornerRadius = self.typeView.height/2;
}

- (void)setType:(TeamPalyerType)type {
    
    _type = type;
    switch (type) {
        case TeamPalyerType_Captain:
            self.typeLabel.text = LS(@"team.home.CPT");
            self.typeView.backgroundColor = [UIColor colorWithHex:0xcf3e3e];
            break;
        case TeamPalyerType_ViceCaptain:
            self.typeLabel.text = LS(@"team.home.V-CPT");
            self.typeView.backgroundColor = [UIColor colorWithHex:0xd58d1c];
            break;
        case TeamPalyerType_Ordinary:
            self.typeLabel.text = LS(@"");
            self.typeView.backgroundColor = [UIColor clearColor];
            break;
            
        default:
            break;
    }
}

@end
