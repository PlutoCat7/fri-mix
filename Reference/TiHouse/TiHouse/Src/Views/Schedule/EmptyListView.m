//
//  EmptyListView.m
//  TiHouse
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "EmptyListView.h"

@implementation EmptyListView

- (IBAction)addSchduleClick:(id)sender {
    
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
