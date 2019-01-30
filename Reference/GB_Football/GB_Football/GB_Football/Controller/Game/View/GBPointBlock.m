//
//  GBPointBlock.m
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPointBlock.h"
#import "XXNibBridge.h"

IB_DESIGNABLE

@implementation GBPoint

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:(0.0/255.0) green:(0xfe*1.0f/255.0) blue:(0xa6*1.0f/255.0) alpha:1.0] CGColor]));
    CGContextFillPath(ctx);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

@end


@interface GBPointBlock()<XXNibBridge>

@end
@implementation GBPointBlock

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
