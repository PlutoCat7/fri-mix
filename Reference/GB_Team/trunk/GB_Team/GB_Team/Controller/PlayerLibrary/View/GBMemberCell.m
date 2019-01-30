//
//  GBMemberCell.m
//  GB_Team
//
//  Created by Pizza on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMemberCell.h"
#import "UIImageView+WebCache.h"

@interface GBMemberCell()
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@end
@implementation GBMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
}

-(void)setSelectState:(SELECT_STATE)selectState
{
    _selectState = selectState;
    switch (selectState) {
        case STATE_NOMAL:
        {
            self.cornerView.layer.borderColor = [UIColor colorWithHex:0x494949].CGColor;
            self.rightImageView.image = [UIImage imageNamed:@"delete.png"];
            self.rightImageView.hidden = YES;
            self.rightButton.enabled = NO;
        }
            break;
        case STATE_DELETE:
        {
            self.cornerView.layer.borderColor = [UIColor colorWithHex:0x494949].CGColor;
            self.rightImageView.image = [UIImage imageNamed:@"delete.png"];
            self.rightImageView.hidden = NO;
            self.rightButton.enabled = YES;
        }
            break;
        case STATE_UNSELECT:
        {
            self.cornerView.layer.borderColor = [UIColor colorWithHex:0x494949].CGColor;
            self.rightImageView.image = [UIImage imageNamed:@"add2.png"];
            self.rightImageView.hidden = NO;
            self.rightButton.enabled = NO;
        }
            break;
        case STATE_SELECTED:
        {
            self.cornerView.layer.borderColor = [UIColor colorWithHex:0x01ff00].CGColor;
            self.rightImageView.image = [UIImage imageNamed:@"delete.png"];
            self.rightImageView.hidden = NO;
            self.rightButton.enabled = NO;
        }
            break;
        default:
            break;
    }
}

- (void)refreshWithPlayer:(PlayerInfo *)playerInfo {
    
    if (playerInfo == nil) {
        return;
    }
    UIImage *placeholderImage = playerInfo.image?playerInfo.image:[UIImage imageNamed:@"portrait_placeholder"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:playerInfo.imageUrl] placeholderImage:placeholderImage];
    self.playerNameLabel.text = playerInfo.playerName;
    self.ageLabel.text = [NSString stringWithFormat:@"%td", playerInfo.playerAge];
    self.playerNumberLabel.text = [NSString stringWithFormat:@"%td", playerInfo.playerNum];
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:playerInfo.position]) {
        selectList = [playerInfo.position componentsSeparatedByString:@","];
    }
    if (selectList.count > 0) {
        self.posIcon1.hidden = NO;
        self.posIcon1.index = selectList.firstObject.integerValue;
    }
    if (selectList.count > 1) {
        self.posIcon2.hidden = NO;
        self.posIcon2.index = selectList.lastObject.integerValue;
    }
}
@end
