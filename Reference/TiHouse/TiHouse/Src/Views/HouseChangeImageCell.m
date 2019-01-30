//
//  HouseChangeImageCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseChangeImageCell.h"

@implementation HouseChangeImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        _imageV.layer.cornerRadius = 6.0f;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageV];
        
        _vidoImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, self.width/2, self.width/2)];
        _vidoImage.image = [UIImage imageNamed:@"video_icon"];
        _vidoImage.contentMode = UIViewContentModeScaleAspectFill;
        //        _vidoImage.center = self.center;
        [self.contentView addSubview:_vidoImage];
        
    }
    return self;
}



@end

