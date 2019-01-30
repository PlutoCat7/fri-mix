//
//  GBImageButtonView.m
//  GB_Team
//
//  Created by Pizza on 16/9/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBImageButtonView.h"
#import "XXNibBridge.h"
#import <pop/POP.h>

@interface GBImageButtonView()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIImageView *nomalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *highLightImageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation GBImageButtonView

-(void)setNomalImage:(UIImage *)nomalImage
{
    _nomalImage = nomalImage;
    if (nomalImage == nil) {
        return;
    }
    self.nomalImageView.image = _nomalImage;
}

-(void)setHighLightImage:(UIImage *)highLightImage
{
    _highLightImage = highLightImage;
    if (highLightImage == nil) {
        return;
    }
    self.highLightImageView.image = _highLightImage;
}

- (IBAction)actionPressButton:(id)sender {
}

@end
