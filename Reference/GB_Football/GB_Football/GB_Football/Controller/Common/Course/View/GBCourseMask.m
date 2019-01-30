//
//  GBCourseMask.m
//  GB_Football
//
//  Created by Pizza on 2017/3/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBCourseMask.h"
#import "XXNibBridge.h"
#import "NoReMindManager.h"

@interface GBCourseMask()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *noRemindButton;
@property (assign, nonatomic) COURSE_MASK_TYPE type;
@end


@implementation GBCourseMask

-(void)showWithType:(COURSE_MASK_TYPE)type{
    self.hidden = NO;
    self.alpha  = 1;
    self.type = type;
    switch (type) {
        case COURSE_MASK_MENU:
        {
            self.topConstraint.constant = 0;
            self.imageView.image = [UIImage imageNamed:@"maskMenu"];
            self.closeButton.hidden = NO;
            self.noRemindButton.hidden = NO;
        }
            break;
        case COURSE_MASK_FOOTBALL:
        {
             self.topConstraint.constant = kUIScreen_NavigationBarHeight;
             self.imageView.image = [UIImage imageNamed:@"maskFootBall"];
             self.closeButton.hidden = NO;
             self.noRemindButton.hidden = NO;
        }
            break;
        case COURSE_MASK_COMPLETE:
        {
            self.topConstraint.constant = kUIScreen_NavigationBarHeight;
            self.imageView.image = [UIImage imageNamed:@"Time_r"];
            self.closeButton.hidden = NO;
            self.noRemindButton.hidden = NO;
        }
            break;
        case COURSE_MASK_TEAM:
        {
            self.topConstraint.constant = 0;
            self.imageView.image = [UIImage imageNamed:@"team_tutorial"];
            self.closeButton.hidden = YES;
            self.noRemindButton.hidden = NO;
            [self.noRemindButton setImage:[UIImage imageNamed:@"knowBtn"] forState:UIControlStateNormal];
            [self.noRemindButton setImage:[UIImage imageNamed:@"knowBtn"] forState:UIControlStateSelected];
        }
            break;

        default:
            break;
    }
}

// 点击了不再提醒
- (IBAction)actionNoReMindButton:(id)sender {
    self.hidden = YES;
    self.noRemindButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.noRemindButton.transform = CGAffineTransformIdentity;
                        } completion:nil];
    switch (self.type) {
        case COURSE_MASK_MENU:
        {
            [NoRemindManager sharedInstance].tutorialMaskMenu = YES;
        }
            break;
        case COURSE_MASK_FOOTBALL:
        {
            [NoRemindManager sharedInstance].tutorialMaskFootBall = YES;
        }
            break;
        case COURSE_MASK_COMPLETE:
        {
            [NoRemindManager sharedInstance].tutorialMaskCompletGame = YES;
        }
            break;
        case COURSE_MASK_TEAM:
        {
            [NoRemindManager sharedInstance].tutorialMaskTeam = YES;
        }
            break;

        default:
            break;
    }
    BLOCK_EXEC(self.action);
}

// 点击了我知道了
- (IBAction)actionCloseButton:(id)sender {
    self.hidden = YES;
    self.closeButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.closeButton.transform = CGAffineTransformIdentity;
                        } completion:nil];
    BLOCK_EXEC(self.action);
}

@end
