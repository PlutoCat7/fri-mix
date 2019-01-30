//
//  LocationCoordinateInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationCoordinateInfo : YAHActiveObject

@property (nonatomic, assign) CLLocationDegrees lat;
@property (nonatomic, assign) CLLocationDegrees lon;
@property (nonatomic, assign) CLLocationCoordinate2D location;

- (instancetype)initWithLon:(CLLocationDegrees)lon lat:(CLLocationDegrees)lat;

- (NSString *)locationString;

@end
