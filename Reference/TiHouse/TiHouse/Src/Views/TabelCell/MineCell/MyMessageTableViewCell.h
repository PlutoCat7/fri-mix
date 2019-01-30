//
//  MyMessageTableViewCell.h
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface MyMessageTableViewCell : CommonTableViewCell
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end
