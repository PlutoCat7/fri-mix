//
//  UserRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/16.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

+ (void)userLogin:(NSString *)loginId code:(NSString *)code handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"login",
                                 @"do":@"user",
                                 @"mobile":loginId,
                                 @"code":code};
    
    [self POSTWithParameters:parameters responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponseInfo *info = result;
            [RawCacheManager sharedRawCacheManager].userInfo = info.data;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)userRegister:(NSString *)loginId code:(NSString *)code registerType:(NSString *)registerType fromMobile:(NSString *)fromMobile handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"reg",
                                 @"do":@"user",
                                 @"mobile":loginId,
                                 @"code":code, @"groupId":registerType, @"fromMobile":fromMobile
                                 };
    
    [self POSTWithParameters:parameters responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponseInfo *info = result;
            [RawCacheManager sharedRawCacheManager].userInfo = info.data;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)refreshUserInfoWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"info",
                                 @"do":@"user",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponseInfo *info = result;
            [RawCacheManager sharedRawCacheManager].userInfo = info.data;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)userSupplement:(NSString *)cer_corp cer_no:(NSString *)cer_no cer_person:(NSString *)cer_person cer_addr:(NSString *)cer_addr cer_pic1_id:(NSString *)cer_pic1_id handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"save1",
                                 @"do":@"user",
                                 @"cer_corp":cer_corp,
                                 @"cer_no":cer_no,
                                 @"cer_person":cer_person,
                                 @"cer_addr":cer_addr,
                                 @"cer_pic1_id":cer_pic1_id,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)saveUserNick:(NSString *)nick handler:(RequestCompleteHandler)handler {

    NSDictionary *parameters = @{@"act":@"save3",
                                 @"do":@"user",
                                 @"nick":nick,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)saveUserAvatorId:(NSString *)avatorId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"save2",
                                 @"do":@"user",
                                 @"attachmentId":avatorId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)uploadImageWithImage:(UIImage *)image handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"up",
                                 @"do":@"pub",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        //[formData app]
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/png"];
    } progress:nil responseClass:[AttachmentResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            AttachmentResponse *response = result;
            BLOCK_EXEC(handler, response.data, nil);
        }
    }];
}

+ (void)getAddressListWithHandler:(RequestCompleteHandler)handler {

    NSDictionary *parameters = @{@"act":@"list",
                                 @"do":@"address",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[AddressListResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            AddressListResponse *info = result;
            BLOCK_EXEC(handler, info.data.list, nil);
        }
    }];
}

+ (void)setDefaultAddressWithAddressId:(NSString *)addresId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"setd",
                                 @"do":@"address",
                                 @"aid":addresId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)deleteAddressWithAddressId:(NSString *)addresId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"remove",
                                 @"do":@"address",
                                 @"aid":addresId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)saveAddressWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address province:(NSString *)province city:(NSString *)city area:(NSString *)area addressId:(NSString *)addressId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"save",
                                 @"do":@"address",
                                 @"realname":name,
                                 @"mobile":phone,
                                 @"address":address,
                                 @"province":province,
                                 @"city":city,
                                 @"area":area,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    if (addressId) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [tmpDic setObject:addressId forKey:@"aid"];
        parameters = [tmpDic copy];
    }
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getAreaDataWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"area",
                                 @"do":@"address"};
    
    [self POSTWithParameters:parameters responseClass:[AreaDataResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            AreaDataResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

#pragma mark - 签到

+ (void)getAttendanceDataWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"signOpt",
                                 @"do":@"user",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId
                                 };
    
    [self POSTWithParameters:parameters responseClass:[AttendanceSituationResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            AttendanceSituationResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)doAttendanceWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"sign",
                                 @"do":@"user",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId
                                 };
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

@end
