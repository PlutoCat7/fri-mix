//
//  SearchSegmentView.m
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SearchSegmentView.h"
#import "XXNibBridge.h"

@interface SearchSegmentView () <XXNibBridge>

@property (weak, nonatomic) IBOutlet UIButton *picMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *artMenuButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftLayoutConstraint;


@end

@implementation SearchSegmentView

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(200, 44);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animateLine:NO];
    });
}

- (IBAction)actionPic:(id)sender {
    
    self.picMenuButton.selected = YES;
    self.artMenuButton.selected = NO;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(searchSegmentViewMenuChange:Index:)]) {
        [_delegate searchSegmentViewMenuChange:self Index:0];
    }
}

- (IBAction)actionArt:(id)sender {
    
    self.picMenuButton.selected = NO;
    self.artMenuButton.selected = YES;
    [self animateLine:YES];
    
    if ([_delegate respondsToSelector:@selector(searchSegmentViewMenuChange:Index:)]) {
        [_delegate searchSegmentViewMenuChange:self Index:1];
    }
}

#pragma mark - Private

- (void)animateLine:(BOOL)animate {
    
    UIButton *selectButton = self.picMenuButton;
    if (_artMenuButton.selected) {
        selectButton = _artMenuButton;
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
