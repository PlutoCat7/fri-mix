//
//  GBRankCell.m
//  GB_Football
//
//  Created by Pizza on 16/9/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRankCell.h"

@interface GBRankCell()
// 黑色块
@property (weak, nonatomic) IBOutlet UIView *blackBlock;

@end

@implementation GBRankCell

- (void)setRankStyle:(RANK_STYLE)rankStyle
{
    switch (rankStyle) {
        case RANK_NORMAL:
            self.rankLabel.textColor = [UIColor whiteColor];
            break;
        case RANK_1:
            self.rankLabel.textColor = [UIColor colorWithHex:0x01ff00];
            break;
        case RANK_2:
            self.rankLabel.textColor = [UIColor colorWithHex:0xffec00];
            break;
        case RANK_3:
            self.rankLabel.textColor = [UIColor colorWithHex:0x00ffe8];
            break;
        case RANK_SELF:
            self.rankLabel.textColor = [UIColor colorWithHex:0xfd000f];
            break;
        default:
            break;
    }
}

-(void)setIsSelf:(BOOL)isSelf
{
    _isSelf = isSelf;
    if(_isSelf)
    {
        self.blackBlock.alpha = 1.0f;
    }
    else
    {
        self.blackBlock.alpha = 0.0f;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headImageView.clipsToBounds = YES;
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
    });
}

@end
