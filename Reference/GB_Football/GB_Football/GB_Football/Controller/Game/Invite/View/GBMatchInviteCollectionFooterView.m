//
//  GBMatchInviteCollectionFooterView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMatchInviteCollectionFooterView.h"

@implementation GBMatchInviteCollectionFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsUnFlod:(BOOL)isUnFlod {
    
    _isUnFlod = isUnFlod;
    if (isUnFlod) {
        [self.arrowButton setTransform:CGAffineTransformMakeRotation(0)];
    }else {
        [self.arrowButton setTransform:CGAffineTransformMakeRotation(M_PI)];
    }
}

- (IBAction)actionFold:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFoldButton:)]) {
        
        [self.delegate didClickFoldButton:self];
    }
}

@end
