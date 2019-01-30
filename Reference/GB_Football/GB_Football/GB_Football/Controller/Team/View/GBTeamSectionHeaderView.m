//
//  GBTeamSectionHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamSectionHeaderView.h"

@interface GBTeamSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *tracticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teammateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemWidthConstraint;
@property (nonatomic, assign) BOOL isHideNewTeammate;

@end

@implementation GBTeamSectionHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
}

- (void)localizeUI {
    
    self.dataLabel.text = LS(@"team.home.data");
    self.tracticsLabel.text = LS(@"team.home.tractics");
    self.scheduleLabel.text = LS(@"team.home.record");
    self.rankLabel.text = LS(@"team.home.rank");
    self.teammateLabel.text = LS(@"team.home.new.teammate");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.itemWidthConstraint.constant = _isHideNewTeammate?1.f/4*self.width:1.f/5*self.width;
}

- (void)hideNewTeammateView:(BOOL)isHide {
    
    _isHideNewTeammate = isHide;
    [self setNeedsLayout];
}

#pragma mark - Action

- (IBAction)actionData:(id)sender {
    
    [self didClickItemWithIndex:0];
}

- (IBAction)actionTractics:(id)sender {
    
    [self didClickItemWithIndex:1];
}
- (IBAction)actionSchedule:(id)sender {
    
    [self didClickItemWithIndex:2];
}

- (IBAction)actionRank:(id)sender {
    [self didClickItemWithIndex:3];
}

- (IBAction)actionTeammate:(id)sender {
    
    [self didClickItemWithIndex:4];
}



- (void)didClickItemWithIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(didClickTeamSectionHeaderView:itemIndex:)]) {
        [self.delegate didClickTeamSectionHeaderView:self itemIndex:index];
    }
}

@end
