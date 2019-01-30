//
//  GBRingCell.m
//  GB_Team
//
//  Created by Pizza on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRingCell.h"

@implementation GBRingCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionDoubleTaps:)];
    tapGesture.numberOfTapsRequired=2;
    [self.contentView addGestureRecognizer:tapGesture];
    [self.batteryButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)setSelectState:(RING_STATE)selectState {
    
    _selectState = selectState;
    switch (selectState) {
        case STATE_NOMAL:
        {
            self.batteryButton.userInteractionEnabled = YES;
            self.batteryButton.hidden = NO;
            self.yesImageView.alpha = 0.f;
            [self.batteryButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            [self.batteryButton setTitle:@"检测电量" forState:UIControlStateNormal];
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
            break;
        case STATE_UNSELECT:
        {
            self.batteryButton.hidden = YES;
            self.yesImageView.alpha = 0.1f;
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
            break;
        case STATE_SELECTED:
        {
            self.batteryButton.hidden = YES;
            self.yesImageView.alpha = 1.f;
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
            break;
        case STATE_SHOW_BATTERY:
        {
            self.batteryButton.userInteractionEnabled = NO;
            self.batteryButton.hidden = NO;
            self.yesImageView.alpha = 0.f;
            [self.batteryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.batteryButton setTitle:[NSString stringWithFormat:@"%td%%",self.batteryInt] forState:UIControlStateNormal];
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
           break;
        case STATE_FAIL_RETRY:
        {
            self.batteryButton.userInteractionEnabled = YES;
            self.batteryButton.hidden = NO;
            self.yesImageView.alpha = 0.f;
            [self.batteryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.batteryButton setTitle:@"重新检测" forState:UIControlStateNormal];
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
            break;
        case STATE_GETTING:
        {
            self.batteryButton.hidden = YES;
            self.yesImageView.alpha = 0.f;
            [self.activity startAnimating];
            self.activity.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (IBAction)actionPressBatteryCheck:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GBRingCell:didPressGetBatteryWithState:)]){
        [self.delegate GBRingCell:self didPressGetBatteryWithState:self.selectState];
    }
}
- (void)actionDoubleTaps:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GBRingCell:didDoubleTapsWithState:)]){
        [self.delegate GBRingCell:self didDoubleTapsWithState:self.selectState];
    }
}

@end
