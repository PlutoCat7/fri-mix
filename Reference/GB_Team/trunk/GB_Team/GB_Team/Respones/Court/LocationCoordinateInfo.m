//
//  LocationCoordinateInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LocationCoordinateInfo.h"

@implementation LocationCoordinateInfo

- (instancetype)initWithLon:(CLLocationDegrees)lon lat:(CLLocationDegrees)lat {
    
    if(self=[super init]){
        _lon = lon;
        _lat = lat;
    }
    return self;
}

- (CLLocationCoordinate2D)location {
    
    CLLocationCoordinate2D location;
    location.longitude = self.lon;
    location.latitude = self.lat;
    
    return location;
}

- (NSString *)locationString {
    
    NSDictionary *dic = @{@"lon":@(self.lon),
                          @"lat":@(self.lat)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    return json;
}


@end
