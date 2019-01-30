//
//  ModelLabelRequest.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ModelLabelRequest.h"

@implementation ModelLabelRequest

+ (void)getModelLabelListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/lable/list";
    [self POST:urlString parameters:nil responseClass:[FindPhotoLabelResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindPhotoLabelResponse *response = (FindPhotoLabelResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getModelThingListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/thing/list";
    [self POST:urlString parameters:nil responseClass:[FindPhotoThingResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindPhotoThingResponse *response = (FindPhotoThingResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getModelBrandListWithHandler:(NSString *)key handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/outer/brand/listBySearch";
    NSDictionary *parameters = @{@"searchName":key};
    [self POST:urlString parameters:parameters responseClass:[FindPhotoThingResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindPhotoThingResponse *response = (FindPhotoThingResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getModelStyleListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/style/list";
    [self POST:urlString parameters:nil responseClass:[FindPhotoStyleResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            FindPhotoStyleResponse *response = (FindPhotoStyleResponse *)result;
            if (handler) {
                handler(response.data, nil);
            }
        }
    }];
}

+ (void)getSoulFolderWithHandler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/soulfolder/listByUid";
    [self POST:urlString parameters:nil responseClass:[SoulFolderResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            SoulFolderResponse *response = (SoulFolderResponse *)result;
            if (handler) {
                handler(response.data.soulfolderList, nil);
            }
        }
    }];
}

+ (void)addSoulFolderWithName:(NSString *)folderName handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/soulfolder/add";
    
    NSDictionary *parameters = @{@"soulfoldername":folderName};
    [self POST:urlString parameters:parameters responseClass:[FindPhotoStyleResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            if (handler) {
                handler(nil, nil);
            }
        }
    }];
}

@end
