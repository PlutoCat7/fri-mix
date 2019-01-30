//
//  HouerInfoMediaItemCCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HouerInfoMediaItemCCell.h"

@interface HouerInfoMediaItemCCell()


@end

@implementation HouerInfoMediaItemCCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_imageV) {
            _imageV = [[UIImageView alloc]init];
            _imageV.contentMode = UIViewContentModeScaleAspectFill;
            _imageV.clipsToBounds = YES;
            [self.contentView addSubview:_imageV];
            [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
        }
        
        if (!_cornerClock) {
            _cornerClock = [[UIImageView alloc]init];
            _cornerClock.contentMode = UIViewContentModeScaleAspectFill;
            _cornerClock.hidden = YES;
            _cornerClock.clipsToBounds = YES;
            _cornerClock.image = [UIImage imageNamed:@"cornerClock"];
            [self.contentView addSubview:_cornerClock];
            [_cornerClock mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.top.and.right.equalTo(self.contentView);
            }];
        }
        
        if (!_shade) {
            _shade = [[UIView alloc]init];
            _shade.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            _shade.hidden = YES;
            [self.contentView addSubview:_shade];
            [_shade mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        if (!_UnImaCount) {
            _UnImaCount = [UIButton buttonWithType:UIButtonTypeCustom];
            [_UnImaCount setImage:[UIImage imageNamed:@"image_Icon"] forState:UIControlStateNormal];
            [_UnImaCount setTitle:@"+5" forState:UIControlStateNormal];
            _UnImaCount.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
            [_UnImaCount setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -23)];
            [_UnImaCount setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            _UnImaCount.userInteractionEnabled = NO;
            [_shade addSubview:_UnImaCount];
            [_UnImaCount mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 30));
                make.center.equalTo(_shade);
            }];
        }
        
        if (!_vidoImage) {
            _vidoImage = [[UIImageView alloc]init];
            _vidoImage.contentMode = UIViewContentModeScaleAspectFill;
            _vidoImage.image = [UIImage imageNamed:@"video_icon"];
            _shade.hidden = YES;
            [self.contentView addSubview:_vidoImage];
            [_vidoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(_vidoImage.image.size);
                make.centerX.equalTo(_shade);
//                make.centerY.equalTo(_imageV).offset(-80);
//                make.centerY.equalTo(self);
                make.centerY.equalTo(_imageV);
            }];
        }
        
        
    }
    return self;
}

@end

