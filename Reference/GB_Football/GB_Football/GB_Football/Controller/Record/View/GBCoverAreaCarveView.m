//
//  GBCoverAreaCarveView.m
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBCoverAreaCarveView.h"

@interface GBCoverAreaCarveView ()

@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;

@end

@implementation GBCoverAreaCarveView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self localizeUI];
}

- (void)localizeUI {
    
    UIFont *italicFont  = [UIFont autoItalicAndBoldFontOfSize:14.0f];
    self.threeButton.titleLabel.font = italicFont;
    self.sixButton.titleLabel.font = italicFont;
    self.nineButton.titleLabel.font = italicFont;
    
    [self.threeButton setTitle:LS(@"gamedata.cover.area.three") forState:UIControlStateNormal];
    [self.sixButton setTitle:LS(@"gamedata.cover.area.six") forState:UIControlStateNormal];
    [self.nineButton setTitle:LS(@"gamedata.cover.area.nine") forState:UIControlStateNormal];
}

#pragma mark - Public

- (void)selectWithIndex:(NSInteger)index {
    
    if (index == 0) {
        [self actionThree:nil];
    }else if (index == 1) {
        [self actionSix:nil];
    }else if (index == 2) {
        [self actionNine:nil];
    }
}

#pragma mark - Action

- (IBAction)actionThree:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_3Area];
    
    self.threeButton.selected = YES;
    self.sixButton.selected = NO;
    self.nineButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(didSelectCoverAreaCarveViewWithIndex:)]) {
        [self.delegate didSelectCoverAreaCarveViewWithIndex:0];
    }
}

- (IBAction)actionSix:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_6Area];
    
    self.threeButton.selected = NO;
    self.sixButton.selected = YES;
    self.nineButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(didSelectCoverAreaCarveViewWithIndex:)]) {
        [self.delegate didSelectCoverAreaCarveViewWithIndex:1];
    }
}

- (IBAction)actionNine:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_9Area];
    
    self.threeButton.selected = NO;
    self.sixButton.selected = NO;
    self.nineButton.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(didSelectCoverAreaCarveViewWithIndex:)]) {
        [self.delegate didSelectCoverAreaCarveViewWithIndex:2];
    }
}

@end
