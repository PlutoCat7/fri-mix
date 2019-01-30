//
//  GBRecordTeamCell.m
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordTeamCell.h"

@interface GBRecordTeamCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *courtLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@end

@implementation GBRecordTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithMatchRecordInfo:(MatchRecordInfo *)recordInfo {
    
    if (recordInfo == nil) {
        return;
    }
    
    self.nameLbl.text = recordInfo.matchName;
    self.courtLbl.text = recordInfo.courtName;
    
    NSDate *matchTime = [NSDate dateWithTimeIntervalSince1970:recordInfo.matchTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.dateLbl.text = [formatter stringFromDate:matchTime];
}

@end
