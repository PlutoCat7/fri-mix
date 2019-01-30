//
//  GBDarkButton.m
//  GB_Football
//
//  Created by Pizza on 2016/11/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBDarkButton.h"

@implementation CALayer (Additions)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end

@implementation GBDarkButton

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.backgroundColor = enabled?[UIColor clearColor]:[ColorManager disableColor];
}



@end
