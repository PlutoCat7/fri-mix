//
//  GBGameTimeDivisionFooterView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTimeDivisionFooterView.h"

@implementation GBGameTimeDivisionFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
}

- (void)localizeUI {
    
    [self.delButton setTitle:LS(@"multi-section.delete") forState:UIControlStateNormal];
    [self.addButton setTitle:LS(@"multi-section.add") forState:UIControlStateNormal];
}

- (void)setAddButtonEnable:(BOOL)enable {
    
    self.addButton.enabled = enable;
    self.addButton.alpha = enable?1.0f:0.2;
}

- (void)setDelButtonEnable:(BOOL)enable {
    
    self.delButton.enabled = enable;
    self.delButton.alpha = enable?1.0f:0.2;
}

- (IBAction)actionDelete:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDelete)]) {
        [self.delegate didClickDelete];
    }
}

- (IBAction)actionAdd:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAdd)]) {
        [self.delegate didClickAdd];
    }
}

@end
