//
//  FindPhotoHandleTips2View.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoHandleTips2View.h"

@implementation FindPhotoHandleTips2View

+ (instancetype)showWithSuperView:(UIView *)superView {
    
    FindPhotoHandleTips2View *view = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoHandleTips2View" owner:self options:nil].firstObject;
    [superView addSubview:view];
    [view performSelector:@selector(hideAction) withObject:nil afterDelay:3.0f];
    
    return view;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.centerX = self.superview.width/2;
    self.bottom = self.superview.height;
    self.size = CGSizeMake(self.superview.width, kRKBWIDTH(70));
}

- (void)hideAction {
    
    [self removeFromSuperview];
}


@end
