//
//  TimeDivisionRecordTableViewHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionRecordTableViewHeaderView.h"

@interface TimeDivisionRecordTableViewHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation TimeDivisionRecordTableViewHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
}

- (void)localizeUI {
    
    self.sectionLabel.text = LS(@"multi-section.section.title");
    self.beginLabel.text = LS(@"multi-section.section.begin");
    self.endLabel.text = LS(@"multi-section.section.end");
}

@end
