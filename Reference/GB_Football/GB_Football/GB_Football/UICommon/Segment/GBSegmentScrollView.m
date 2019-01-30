//
//  GBSegmentScrollView.m
//  GB_Football
//
//  Created by wsw on 16/8/16.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSegmentScrollView.h"
#import "AppDelegate.h"

@implementation GBSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.navigationController.interactivePopGestureRecognizer) {
            [self.panGestureRecognizer requireGestureRecognizerToFail:appDelegate.navigationController.interactivePopGestureRecognizer];
        }
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer.state != 0 && self.contentOffset.x == self.contentSize.width-self.width && self.isNeedDelete) {
        return YES;
    } else {
        return NO;
    }
}


@end
