//
//  GBTeamSearchCell.m
//  GB_Football
//
//  Created by gxd on 17/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamSearchCell.h"

@interface GBTeamSearchCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatorContainerView;

@end

@implementation GBTeamSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.width/2;
    self.avatorContainerView.layer.cornerRadius = self.avatorContainerView.width/2;
    
}

@end
