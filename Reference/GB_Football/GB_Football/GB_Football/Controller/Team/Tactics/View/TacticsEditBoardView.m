//
//  TacticsEditBoardView.m
//  GB_Football
//
//  Created by yahua on 2017/12/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TacticsEditBoardView.h"

@interface TacticsEditBoardView ()

@property (weak, nonatomic) IBOutlet UIView *editBoardView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *homeAddButton;
@property (weak, nonatomic) IBOutlet UIButton *guestAddButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation TacticsEditBoardView

#pragma mark - Public

- (void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    self.homeAddButton.enabled = !isEdit;
    self.guestAddButton.enabled = !isEdit;
}

- (void)setIsPlaying:(BOOL)isPlaying {
    
    _isPlaying = isPlaying;
    self.playButton.selected = isPlaying;
    
    if (isPlaying) {
        self.homeAddButton.enabled = NO;
        self.guestAddButton.enabled = NO;
        self.backButton.enabled = NO;
    }else {
        self.homeAddButton.enabled = !_isEdit;
        self.guestAddButton.enabled = !_isEdit;
        self.backButton.enabled = _isCanBack;
    }
}

- (void)setIsCanBack:(BOOL)isCanBack {
    
    _isCanBack = isCanBack;
    self.backButton.enabled = isCanBack;
}

- (void)setHideEditBoard:(BOOL)hideEditBoard {
    
    _hideEditBoard = hideEditBoard;
    self.editBoardView.hidden = hideEditBoard;
}

#pragma mark - Action

- (IBAction)actionHomePlayerAdd:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddHomeTeamPlayer)]) {
        [self.delegate didClickAddHomeTeamPlayer];
    }
}

- (IBAction)actionGuestPlayerAdd:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddGuestTeamPlayer)]) {
        [self.delegate didClickAddGuestTeamPlayer];
    }
}
- (IBAction)actionRevoke:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRevoke)]) {
        [self.delegate didClickRevoke];
    }
}
- (IBAction)actionEdit:(id)sender {
    
    self.editButton.selected = !self.editButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBrushTactics:)]) {
        [self.delegate didClickBrushTactics:self.editButton.selected];
    }
}
- (IBAction)actionPlay:(id)sender {
    
    BOOL isPaly = !self.playButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPlay:)]) {
        [self.delegate didClickPlay:isPaly];
    }
}
@end
