//
//  GBTeamGuestSectionHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamGuestSectionHeaderView.h"

@implementation GBTeamGuestSectionHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
}

- (void)localizeUI {
    
    self.staticTeamDescLabel.text = LS(@"team.setting.label.introduct");
}

@end
