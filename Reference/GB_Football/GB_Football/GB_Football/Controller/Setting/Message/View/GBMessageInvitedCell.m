//
//  GBMessageInvitedCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMessageInvitedCell.h"

@interface GBMessageInvitedCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@end

@implementation GBMessageInvitedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionJion:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickJoinButton:)]) {
        [self.delegate didClickJoinButton:self];
    }
}

@end
