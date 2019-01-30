//
//  GBEmptyView.m
//  GB_Football
//
//  Created by Pizza on 16/9/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBEmptyView.h"

@interface GBEmptyView()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@end

@implementation GBEmptyView


-(void)setTitle:(NSString *)title {
    _title = title;
    if ([_title length]>0) {
        self.msgLabel.text = _title;
    }
}

-(void)clip:(CGFloat)width {
    self.roundView.layer.cornerRadius  = width;
    self.roundView.layer.masksToBounds = YES;
}

@end
