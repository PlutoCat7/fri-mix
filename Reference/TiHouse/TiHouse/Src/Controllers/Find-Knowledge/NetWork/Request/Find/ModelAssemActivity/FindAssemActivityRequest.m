//
//  FindAssemActivityRequest.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemActivityRequest.h"

@implementation FindAssemActivityRequest

+ (void)getActivityListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/assem/list";
    [self POST:urlString parameters:nil responseClass:[FindAssemActivityResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindAssemActivityResponse *response = (FindAssemActivityResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getActivityListFiveWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/assem/page";
    [self POST:urlString parameters:@{@"start":@"0",
                                      @"limit":@"5"
                                      } responseClass:[FindAssemActivityResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindAssemActivityResponse *response = (FindAssemActivityResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getActivityInfoWithAssemId:(long)assemId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/assem/get";
    [self POST:urlString parameters:@{@"assemid":@(assemId)
                                      } responseClass:[FindAssemActivityDetailResponse class] handler:^(id result, NSError *error) {
                                          
                                          if (error) {
                                              if (handler) {
                                                  handler(nil, error);
                                              }
                                          }else {
                                              FindAssemActivityDetailResponse *response = (FindAssemActivityDetailResponse *)result;
                                              if (handler) {
                                                  handler(response.data, nil);
                                              }
                                          }
                                      }];
}

@end
