//
//  FindDraftTipsView.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindDraftTipsView.h"

@interface FindDraftTipsView ()

@end

@implementation FindDraftTipsView

- (IBAction)actionClose:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(FindDraftTipsView_ClickClose:)]) {
        [_delegate FindDraftTipsView_ClickClose:self];
    }
}

@end
