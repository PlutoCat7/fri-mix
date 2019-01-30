//
//  CourtRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CourtRequest.h"

@implementation CourtRequest

+ (void)getCourtList:(NSString *)name type:(CourtType)courtType cityName:(NSString *)cityName handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"court_list_controller/dolist";
    NSDictionary *parameters = @{@"court_name":[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                 @"city_name":!cityName?@"":cityName,
                                 @"type":@(courtType),
                                 @"is_history":@(1)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[CourtResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CourtResponseInfo *info = (CourtResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)addCourt:(CourtInfo *)courtObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"court_add_controller/doadd";
    NSDictionary *parameters = @{@"court_name":courtObj.courtName == nil ? @"" : courtObj.courtName,
                                 @"court_address":courtObj.courtAddress == nil ? @"" : courtObj.courtAddress,
                                 @"location":courtObj.location.locationString,
                                 @"court_a":courtObj.locA.locationString,
                                 @"court_b":courtObj.locB.locationString,
                                 @"court_c":courtObj.locC.locationString,
                                 @"court_d":courtObj.locD.locationString,
                                 @"city_name":!courtObj.cityName?@"":courtObj.cityName};
    
    [self POST:urlString parameters:parameters responseClass:[CourtAddResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CourtAddResponseInfo *info = (CourtAddResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)deleteDefineCourt:(NSInteger)courtId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"court_del_controller/dodel";
    NSDictionary *parameters = @{@"court_id":@(courtId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];

}

// 预览球场
+ (void)preViewCourt:(CourtInfo *)courtObj handler:(RequestCompleteHandler)handler
{
    NSString *urlString = @"preview_court_controller/dopreview";
    NSDictionary *parameters = @{
                                 @"court_a":courtObj.locA.locationString,
                                 @"court_b":courtObj.locB.locationString,
                                 @"court_c":courtObj.locC.locationString,
                                 @"court_d":courtObj.locD.locationString};
    
    [self POST:urlString parameters:parameters responseClass:[CourtPreViewInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CourtPreViewInfo *info = (CourtPreViewInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
