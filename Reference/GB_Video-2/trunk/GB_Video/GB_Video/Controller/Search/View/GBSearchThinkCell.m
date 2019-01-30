//
//  GBSearchThinkCell.m
//  GB_Video
//
//  Created by gxd on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBSearchThinkCell.h"

@interface GBSearchThinkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *thinkLabel;

@end

@implementation GBSearchThinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsThink:(BOOL)isThink {
    _isThink = isThink;
    self.icon.image = isThink? [UIImage imageNamed:@"find_search"]:[UIImage imageNamed:@"find_record"];
}

-(void)setupConent:(NSString*)conent high:(NSString*)high {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:conent];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x5B5B5B] range:NSMakeRange(0, [conent length])];
    if (self.isThink == YES && ![NSString stringIsNullOrEmpty:high]) {
        NSRange  range = [conent rangeOfString:high];
        if (range.location != NSNotFound) {
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xeb1e23] range:NSMakeRange(range.location, range.length)];
        }
    }
    self.thinkLabel.attributedText = attr;
}

@end
