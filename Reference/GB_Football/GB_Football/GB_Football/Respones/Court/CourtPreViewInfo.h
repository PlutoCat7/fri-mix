//
//  CourtPreViewInfo.h
//  GB_Football
//
//  Created by Pizza on 2016/11/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "LocationCoordinateInfo.h"

@interface PreViewInfo : YAHActiveObject
@property (nonatomic, strong) LocationCoordinateInfo *locA;
@property (nonatomic, strong) LocationCoordinateInfo *locB;
@property (nonatomic, strong) LocationCoordinateInfo *locC;
@property (nonatomic, strong) LocationCoordinateInfo *locD;
@end



@interface CourtPreViewInfo : GBResponseInfo
@property (nonatomic, strong) PreViewInfo *data;
@end
