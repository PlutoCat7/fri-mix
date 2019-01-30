//
//  GBProgressView.m
//  GB_Football
//
//  Created by Pizza on 2016/10/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBProgressView.h"
#import "XXNibBridge.h"
#import "GBUpdateSlider.h"
#import "POPNumberAnimation.h"

@interface GBProgressView()<XXNibBridge,POPNumberAnimationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet GBUpdateSlider *slider;
@property (strong, nonatomic) POPNumberAnimation* numberAnimation;
@end

@implementation GBProgressView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

// 设置状态
-(void)setupState:(GPS_PROGRAM_STATE)state
{
    _state = state;
    switch (state)
    {
        case STATE_IDLE:
        {
            self.percentLabel.text   = LS(@"0");
            self.slider.value = 0.f;
        }
            break;
        case STATE_DOWNLOADING:
        {
            
        }
            break;
        case STATE_DOWNLOAD_FINISH:
        {
            self.percentLabel.text   = LS(@"100");
            self.slider.value = 1.f;
        }
            break;
        case STATE_PROGRAMMING:
        {
            
        }
            break;
        case STATE_PROGRAM_FINISH:
        {
            self.percentLabel.text   = LS(@"100");
            self.slider.value = 1.f;
        }
            break;
        case STATE_PROGRAM_FAIED:
        {
            [self turnToFailed];
        }
            break;
        default:
            break;
    }
}

-(void)setPercent:(CGFloat)percent
{
    _percent = percent;
    self.slider.value = (_percent*1.f)/100;
    self.percentLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
}



#pragma mark - Setter and Getter

- (POPNumberAnimation *)numberAnimation {
    
    if (!_numberAnimation) {
        _numberAnimation = [[POPNumberAnimation alloc]init];
        _numberAnimation.delegate = self;
        _numberAnimation.duration       = 5.f;
    }
    return _numberAnimation;
}

#pragma mark - POPNumberAnimationDelegate

- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue
{
    self.percentLabel.text = [NSString stringWithFormat:@"%td", (NSInteger)currentValue];
    self.slider.value = (currentValue*1.f)/100;;
    if(currentValue == 0)_percent = 0;
}

-(void)turnToFailed
{
    self.numberAnimation.fromValue = _percent;
    self.numberAnimation.toValue = 0;
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];
}


@end
