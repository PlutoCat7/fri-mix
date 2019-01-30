//
//  GBSyncCell.m
//  GB_Team
//
//  Created by weilai on 16/9/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSyncCell.h"

@implementation GBSyncCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setState:(Sync_STATE)state
{
    _state = state;
    switch (_state)
    {
        case STATE_INIT:
        {
            self.slider.value = 0.f;
            self.slider.alpha = 0.f;
            self.yesImageView.alpha  = 0.f;
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            self.syncFailLabel.text = @"";
        }
            break;
        case STATE_UPDATING:
        {
            self.slider.alpha = 1.f;
            self.yesImageView.alpha  = 0.f;
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            self.slider.sliderColor = COLOR_GREEN;
            self.syncFailLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.slider.value*100.f)];
            self.syncFailLabel.textColor = [UIColor greenColor];
        }
            break;
        case STATE_FINISHED:
        {
            self.slider.value = 1.f;
            self.slider.alpha = 1.f;
            self.yesImageView.alpha  = 1.f;
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            self.slider.sliderColor = COLOR_CYAN;
            self.syncFailLabel.text = @"";
        }
            break;
        case STATE_FAIL:
        {
            self.slider.alpha = 1.f;
            self.yesImageView.alpha  = 0.f;
            self.retryButton.alpha   = 1.f;
            self.retryButton.enabled = YES;
            self.slider.sliderColor = COLOR_RED;
            self.syncFailLabel.text = @"同步失败";
            self.syncFailLabel.textColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
}

- (IBAction)actionRetryPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressRetryUpdateButtonWithGBSyncCell:)]) {
        [self.delegate didPressRetryUpdateButtonWithGBSyncCell:self];
    }
}


@end
