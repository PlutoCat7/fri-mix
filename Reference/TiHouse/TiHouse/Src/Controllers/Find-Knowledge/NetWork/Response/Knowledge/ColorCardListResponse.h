//
//  ColorCardListResponse.h
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface ColorModeInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger colorcardid;
@property (strong, nonatomic) NSString *colorcardurl;
@property (assign, nonatomic) BOOL colorcardiscoll;

@end

@interface ColorCardListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<ColorModeInfo *> *data;

@end
