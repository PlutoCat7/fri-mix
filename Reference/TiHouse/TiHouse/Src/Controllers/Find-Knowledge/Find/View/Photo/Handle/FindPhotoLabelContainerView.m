//
//  FindPhotoLabelContainerView.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelContainerView.h"

@implementation FindPhotoLabelContainerView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if ([hitView isKindOfClass:[FindPhotoLabelContainerView class]]) {
        return nil;
    }
    return hitView;
}

- (void)clear {
    
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

@end
