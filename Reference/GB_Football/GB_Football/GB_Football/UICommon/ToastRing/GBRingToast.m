//
//  GBRingToast.m
//  GB_Football
//
//  Created by Pizza on 2016/12/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRingToast.h"
#import <pop/POP.h>
#import "XXNibBridge.h"

@interface GBRingToast()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@end

@implementation GBRingToast

+ (GBRingToast *)showWithTip:(NSString*)tip
{
    GBRingToast *toast = [[[NSBundle mainBundle] loadNibNamed:@"GBRingToast" owner:nil options:nil] lastObject];
    toast.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 60.f,
                             0.82f*[UIScreen mainScreen].bounds.size.height,
                             120, 36);
    toast.tipLabel.text = tip;
    dispatch_async(dispatch_get_main_queue(), ^{
        toast.alphaView.layer.cornerRadius = 18.f;
        toast.alphaView.layer.masksToBounds = YES;
    });
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    [toast start];
    return toast;
}

+ (void)hide
{
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class toastClass = [GBRingToast class];
    for (UIView *tmp in subViewsArray)
    {
        if ([tmp isKindOfClass:toastClass])
        {
            GBRingToast *toast = (GBRingToast *)tmp;
            [toast hide];
        }
    }
}

- (void)hide {
    [self stop];
    [self removeFromSuperview];
}

#pragma mark - Private

-(void)start
{
    
}

-(void)stop
{
    
}

@end
