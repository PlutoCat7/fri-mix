//
//  GBRecordPlayerCell.m
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordPlayerCell.h"
#import "UIImageView+WebCache.h"

@implementation GBRecordPlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    self.headImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
}

- (void)refreshWithMatchPlayerInfo:(MatchPlayerInfo *)matchPlayerInfo {
    
    if (matchPlayerInfo == nil) {
        return;
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:@"portrait_placeholder"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:matchPlayerInfo.image_url] placeholderImage:placeholderImage];
    self.nameLabel.text = matchPlayerInfo.player_name;
    self.numberLabel.text = [NSString stringWithFormat:@"%td", matchPlayerInfo.clothes_no];
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:matchPlayerInfo.position]) {
        selectList = [matchPlayerInfo.position componentsSeparatedByString:@","];
    }
    if (selectList.count > 0) {
        self.positionLabel1.hidden = NO;
        self.positionLabel1.index = selectList.firstObject.integerValue;
    } else {
        self.positionLabel1.hidden = YES;
    }
    if (selectList.count > 1) {
        self.positionLabel2.hidden = NO;
        self.positionLabel2.index = selectList.lastObject.integerValue;
    } else {
        self.positionLabel2.hidden = YES;
    }
    
    self.distanceLabel.text = [self transformDistance:matchPlayerInfo.move_distance];
    self.physicalLabel.text = [NSString stringWithFormat:@"%.1f KCAL", matchPlayerInfo.pc];
    self.speedLabel.text = [NSString stringWithFormat:@"%.1f M/S", matchPlayerInfo.max_speed];
}

- (NSString *)transformDistance:(CGFloat)distance {
    
    if (distance>=1000) {
        return [NSString stringWithFormat:@"%.1f KM", distance/1000];
    }else {
        return [NSString stringWithFormat:@"%td M", (NSInteger) distance];
    }
}

@end
