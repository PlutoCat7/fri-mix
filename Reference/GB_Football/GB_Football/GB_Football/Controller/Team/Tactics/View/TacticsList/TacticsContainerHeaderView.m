//
//  TacticsContainerHeaderView.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsContainerHeaderView.h"

@interface TacticsContainerHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *tacticsButton;
@property (weak, nonatomic) IBOutlet UIButton *lineupButton;

@end

@implementation TacticsContainerHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(200, 44);
}

- (IBAction)actionTactics:(id)sender {
    
    [self.tacticsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lineupButton setTitleColor:[UIColor colorWithHex:0x8f9091] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTactics)]) {
        [self.delegate didClickTactics];
    }
}

- (IBAction)actionLineUp:(id)sender {
    
    [self.lineupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tacticsButton setTitleColor:[UIColor colorWithHex:0x8f9091] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLineUp)]) {
        [self.delegate didClickLineUp];
    }
}

@end
