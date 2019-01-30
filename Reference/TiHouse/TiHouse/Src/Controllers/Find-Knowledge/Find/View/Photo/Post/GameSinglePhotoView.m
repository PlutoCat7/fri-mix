//
//  GameSinglePhotoView.m
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GameSinglePhotoView.h"

@interface GameSinglePhotoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation GameSinglePhotoView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    self.imageView.image = image;
}

- (IBAction)actionClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickWithgameSinglePhotoView:)]) {
        [self.delegate clickWithgameSinglePhotoView:self];
    }
}

@end
