//
//  TimeLineTableViewCell.h
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TallyDetail.h"

@interface TimeLineTableViewCell : CommonTableViewCell

@property (retain, nonatomic) TallyDetail *tDetail;
@property (retain, nonatomic) UIImageView *Img;
@property (nonatomic) BOOL showMoney;

+ (float)getCellHeightWithDetail:(TallyDetail *)tDetail;


@end
