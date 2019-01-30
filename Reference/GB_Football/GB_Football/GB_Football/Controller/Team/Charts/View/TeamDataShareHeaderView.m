//
//  TeamDataShareHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamDataShareHeaderView.h"
#import "GBAvatorView.h"
#import "UIImageView+WebCache.h"

@interface TeamDataShareHeaderView ()
@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *teanNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@end

@implementation TeamDataShareHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.avatorView.bgColor = [UIColor colorWithHex:0x12283d];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)refreshUI:(TeamInfo *)teamInfo {
    
    [self.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:teamInfo.teamIcon] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.teanNameLabel.text = teamInfo.teamName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:teamInfo.foundTime];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@", LS(@"team.data.set.up.time"), [date stringWithFormat:LS(@"team.data.yyyy-MM-dd日")]];
    AreaInfo *areaInfo = [LogicManager findAreaWithProvinceId:teamInfo.provinceId cityId:teamInfo.cityId];
    self.regionLabel.text = [NSString stringWithFormat:@"%@ %@", LS(@"team.data.city"), areaInfo.areaName];
}

@end
