//
//  GBUpdateCell.m
//  GB_Team
//
//  Created by Pizza on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBUpdateCell.h"

@implementation GBUpdateCell

- (void)setState:(UPDATE_STATE)state {
    
    _state = state;
    switch (_state)
    {
        case STATE_INIT:
        {
            self.slider.value = 0.f;
            self.slider.alpha = 0.f;
            
            self.checkButton.alpha   = 1.f;
            self.checkButton.enabled = YES;
            [self.checkButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            [self.checkButton setTitle:LS(@"检测更新") forState:UIControlStateNormal];
            
            self.ringStateLabel.hidden = YES;
            
            self.yesImageView.alpha  = 0.f;
            
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            
            self.stateActivityIndicator.hidden = YES;
            [self.stateActivityIndicator stopAnimating];
        }
            break;
        case STATE_WAITING:
        {
            self.slider.value = 0.f;
            self.slider.alpha = 0.f;
            
            self.checkButton.alpha   = 0.f;
            
            self.ringStateLabel.hidden = YES;
            
            self.yesImageView.alpha  = 0.f;
            
            self.retryButton.alpha   = 0.f;
            
            self.stateActivityIndicator.hidden = NO;
            [self.stateActivityIndicator startAnimating];
        }
            break;
        case STATE_UPDATING:
        {
            self.slider.alpha = 1.f;
            self.slider.sliderColor = COLOR_GREEN;
            
            self.checkButton.alpha   = 0.f;
            
            self.ringStateLabel.hidden = NO;
            self.ringStateLabel.text   = [NSString stringWithFormat:@"%d%%",(int)(self.slider.value*100.f)];
            self.ringStateLabel.textColor = [UIColor greenColor];
            
            self.yesImageView.alpha  = 0.f;
            
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            
            self.stateActivityIndicator.hidden = YES;
            [self.stateActivityIndicator stopAnimating];
        }
            break;
        case STATE_FINISHED:
        {
            self.slider.value = 1.f;
            self.slider.alpha = 1.f;
            self.slider.sliderColor = COLOR_CYAN;
            
            self.checkButton.alpha   = 0.f;
            
            self.ringStateLabel.hidden = NO;
            self.ringStateLabel.text = [NSString stringWithFormat:@"100%%"];
            self.ringStateLabel.textColor = [UIColor greenColor];
            
            self.yesImageView.alpha  = 1.f;
            
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            
            self.stateActivityIndicator.hidden = YES;
            [self.stateActivityIndicator stopAnimating];
        }
            break;
        case STATE_FAIL:
        {
            self.slider.alpha = 1.f;
            self.slider.sliderColor = COLOR_RED;
            
            self.checkButton.alpha   = 0.f;
            
            self.ringStateLabel.hidden = NO;
            self.ringStateLabel.text = @"更新失败";
            self.ringStateLabel.textColor = [UIColor redColor];
            
            self.yesImageView.alpha  = 0.f;
            
            self.retryButton.alpha   = 1.f;
            self.retryButton.enabled = YES;
            
            self.stateActivityIndicator.hidden = YES;
            [self.stateActivityIndicator stopAnimating];
        }
            break;
        case STATE_NO_UPDATE:
        {
            self.slider.value = 0.f;
            self.slider.alpha = 0.f;
            
            self.checkButton.alpha   = 0.f;
            
            self.ringStateLabel.hidden = NO;
            self.ringStateLabel.text = @"最新版";
            self.ringStateLabel.textColor = [UIColor greenColor];
            
            self.yesImageView.alpha  = 0.f;
            
            self.retryButton.alpha   = 0.f;
            self.retryButton.enabled = NO;
            
            self.stateActivityIndicator.hidden = YES;
            [self.stateActivityIndicator stopAnimating];
        }
            break;
        default:
            break;
    }
}
- (IBAction)actionCheckUpdatePress:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didPressCheckUpdateButtonWithGBUpdateCell:)]) {
        [self.delegate didPressCheckUpdateButtonWithGBUpdateCell:self];
    }
}

- (IBAction)actionRetryPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressRetryUpdateButtonWithGBUpdateCell:)]) {
        [self.delegate didPressRetryUpdateButtonWithGBUpdateCell:self];
    }
}

@end
