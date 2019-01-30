//
//  HouerInfoMediaItemCCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCCellIdentifier_HouerInfoMediaItem @"HouerInfoMediaItemCCell"

@interface HouerInfoMediaItemCCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UIImageView *cornerClock;
@property (nonatomic, retain) UIButton *UnImaCount;
@property (nonatomic, retain) UIView *shade;//遮罩
@property (nonatomic, retain) UIImageView *vidoImage;

@end

