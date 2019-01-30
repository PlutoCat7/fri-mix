//
//  SegmentScrollView.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SegmentScrollView.h"

@implementation SegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window && window.rootViewController && [window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *) window.rootViewController;
            [self.panGestureRecognizer requireGestureRecognizerToFail:navigationController.interactivePopGestureRecognizer];
        }
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat width = self.frame.size.width;
    if (gestureRecognizer.state != 0 && self.contentOffset.x == self.contentSize.width-width && self.isNeedDelete) {
        return YES;
    } else {
        return NO;
    }
}


@end
