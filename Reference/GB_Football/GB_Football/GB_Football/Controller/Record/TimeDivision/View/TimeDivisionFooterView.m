//
//  TimeDivisionFooterView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionFooterView.h"

@implementation TimeDivisionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)actionClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFooterView)]) {
        [self.delegate didClickFooterView];
    }
}

@end
