//
//  FindSegmentView.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindSegmentView.h"

@interface FindSegmentView ()

@property (weak, nonatomic) IBOutlet UIButton *homeMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionMenuButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftLayoutConstraint;


@end

@implementation FindSegmentView

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(200, 44);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animateLine:NO];
    });
}

- (IBAction)actionHome:(id)sender {
    
    self.homeMenuButton.selected = YES;
    self.attentionMenuButton.selected = NO;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(findSegmentViewMenuChange:Index:)]) {
        [_delegate findSegmentViewMenuChange:self Index:0];
    }
}

- (IBAction)actionAttention:(id)sender {
    
    self.homeMenuButton.selected = NO;
    self.attentionMenuButton.selected = YES;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(findSegmentViewMenuChange:Index:)]) {
        [_delegate findSegmentViewMenuChange:self Index:1];
    }
}

#pragma mark - Private

- (void)animateLine:(BOOL)animate {
    
    UIButton *selectButton = self.homeMenuButton;
    if (_attentionMenuButton.selected) {
        selectButton = _attentionMenuButton;
    }
    if (animate) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lineViewLeftLayoutConstraint.constant = selectButton.centerX-self.lineView.width/2;
            [self layoutIfNeeded];
        } completion:nil];
    }else {
        self.lineViewLeftLayoutConstraint.constant = selectButton.centerX-self.lineView.width/2;
    }
}

@end
