//
//  AssemSegmentView.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemSegmentView.h"

@interface AssemSegmentView ()

@property (weak, nonatomic) IBOutlet UIButton *hotMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *newestMenuButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftLayoutConstraint;

@end

@implementation AssemSegmentView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animateLine:NO];
    });
    self.hotMenuButton.hidden = YES;
    self.lineView.hidden = YES;
}

- (IBAction)actionHot:(id)sender {
    
//    self.hotMenuButton.selected = YES;
    self.newestMenuButton.selected = NO;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(assemSegmentViewMenuChange:Index:)]) {
        [_delegate assemSegmentViewMenuChange:self Index:0];
    }
}

- (IBAction)actionNewest:(id)sender {
    
//    self.hotMenuButton.selected = NO;
    self.newestMenuButton.selected = YES;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(assemSegmentViewMenuChange:Index:)]) {
        [_delegate assemSegmentViewMenuChange:self Index:1];
    }
}

#pragma mark - Private

- (void)animateLine:(BOOL)animate {
    
    UIButton *selectButton = self.newestMenuButton;
    if (_newestMenuButton.selected) {
        selectButton = _newestMenuButton;
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
