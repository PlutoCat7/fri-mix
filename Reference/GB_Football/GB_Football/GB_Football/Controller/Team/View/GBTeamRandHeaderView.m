//
//  GBTeamRandHeaderView.m
//  GB_Football
//
//  Created by gxd on 17/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamRandHeaderView.h"

#import "XXNibBridge.h"
#import "UIImageView+WebCache.h"

@interface GBTeamRandHeaderView()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIView *cityBgView;

@end

@implementation GBTeamRandHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    
    self.logoImageView.clipsToBounds = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.logoImageView.layer setCornerRadius:self.logoImageView.width/2];
        [self.logoImageView.layer setMasksToBounds:YES];
    });
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGRect cityVR = self.cityBgView.frame;
    CGFloat radius = cityVR.size.width / 2 - cityVR.size.height / 2;
    CGFloat spacing = sqrt((radius * radius) / 2.f);
    CGPoint center = CGPointMake(self.bgView.width - spacing, spacing);
    
    self.cityBgView.frame = CGRectMake(center.x - cityVR.size.width / 2, center.y - cityVR.size.height / 2, cityVR.size.width, cityVR.size.height);
    self.cityBgView.transform = CGAffineTransformMakeRotation(M_PI_4);
}

- (void)setRankType:(GBTeamRankType)rankType {
    _rankType = rankType;
    
    [self updateRankTypeUI];
}

- (void)refreshWithTeamRankInfo:(TeamRankInfo *)teamRankInfo {
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:teamRankInfo.teamIcon] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.teamNameLabel.text = teamRankInfo.teamName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", (int)teamRankInfo.score];
    
    AreaInfo *areaInfo = [LogicManager findAreaWithProvinceId:teamRankInfo.provinceId cityId:teamRankInfo.cityId];
    if (areaInfo) {
        NSString *cityName = areaInfo.areaName;
        if (cityName.length == 4) {
            cityName = [cityName substringToIndex:3];
        } else if (cityName.length >= 2) {
            cityName = [cityName substringToIndex:2];
        }
        self.cityNameLabel.text = cityName;
    }
    
}

- (void)updateRankTypeUI {
    if (self.rankType == GBTeamRankType_Glod) {
        self.bgView.clipsToBounds = YES;
        [self.bgView.layer setCornerRadius:5];
        self.bgView.layer.borderWidth = 0.5;
        self.bgView.layer.borderColor = [[UIColor colorWithHex:0x404040] CGColor];
        
        self.rankImageView.image = [UIImage imageNamed:@"gold.png"];
        self.scoreLabel.textColor = [UIColor colorWithHex:0xffc343];
        self.cityNameLabel.backgroundColor = [UIColor colorWithHex:0xffe952];
        
    } else if (self.rankType == GBTeamRankType_Silver) {
        self.rankImageView.image = [UIImage imageNamed:@"silver.png"];
        self.scoreLabel.textColor = [UIColor colorWithHex:0xb7d5e3];
        self.cityNameLabel.backgroundColor = [UIColor colorWithHex:0x84949a];
        
    } else if (self.rankType == GBTeamRankType_Copper) {
        self.rankImageView.image = [UIImage imageNamed:@"copper.png"];
        self.scoreLabel.textColor = [UIColor colorWithHex:0xe3a785];
        self.cityNameLabel.backgroundColor = [UIColor colorWithHex:0x99735e];
        
    }
}
- (IBAction)actionLookUpTeam:(id)sender {
    if (self.didLookUpTeam) {
        self.didLookUpTeam(self.rankType);
    }
}

@end
