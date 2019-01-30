//
//  TiHouse_NetAPIManager.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TiHouse_NetAPIManager.h"
#import "Advert.h"
#import "Login.h"
#import "Houses.h"
#import "AddresManager.h"
#import "Houseperson.h"
#import "Folder.h"
#import "HouseTweet.h"
#import "Budgets.h"
#import "Budgetpro.h"
#import "BudgetThreeClass.h"
#import "Logbudgetopes.h"
#import "TimerTweets.h"
#import "Dairyzan.h"
#import "TweetComment.h"

#import "ColorModel.h"
#import "AddScheduleModel.h"
#import "CloudReListCountModel.h"
#import "CloudReFileListModel.h"
#import "CloudReCollectItemModel.h"
#import "HXPhotoModel.h"
#import "modelDairy.h"
#import "TweetMonthCountS.h"
#import "MonthDairyModel.h"

#import "KnowledgeAdvertisementsDataModel.h"

#import "AdvertisementsDetailDataModel.h"
#import <Qiniu/QiniuSDK.h>

#import "FindAssemarcInfo.h"
#import "FindAssemActivityInfo.h"

#import "DiscoveryAdvertisementsDataModel.h"
#import "DiscoveryListDataModel.h"

#import "PersonProfileDataModel.h"
#import "CollectionNumberListDataModel.h"
#import "NSURL+THVideoCompress.h"

#import "KnowModeInfo.h"

@implementation TiHouse_NetAPIManager

+ (instancetype)sharedManager {
    static TiHouse_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


- (void)request_UnReadNotificationsWithBlock:(void (^)(id data, NSError *error))block{
    NSMutableDictionary *notificationDict = [[NSMutableDictionary alloc] init];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user/getUnreadnumInhome" withParams:@{@"user":@([Login curLoginUserID])} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [notificationDict setValue:@([data[@"data"][@"usernumunreadall"] integerValue]) forKey:kUnReadKey_notification_Me];
            [notificationDict setValue:@([data[@"data"][@"usernumunreadassem"] integerValue]) forKey:kUnReadKey_notification_Find];
            [notificationDict setValue:@([data[@"data"][@"usernumunreadknow"] integerValue]) forKey:kUnReadKey_notification_know];
            block(notificationDict,nil);
        }else{
            block(nil,nil);
        }
    }];
}

- (void)request_WithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            block(data[@"is"],nil);
        }else{
            block(nil,nil);
        }
        
    }];
}

#pragma mark -- Advertising
- (void)request_AdvertisingandBlock:(void (^)(id data, NSError *error))block{
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/advert/getDetail" withParams:nil withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        Advert *model = [Advert mj_objectWithKeyValues:data[@"data"]];
        block(model,nil);
    }];
}
#pragma mark -- UserLogin
- (void)request_OpenIDOAuthUserInfoWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && [data[@"msg"] intValue] == 1010) {
            Login *model = [Login mj_objectWithKeyValues:data[@"data"]];
            block(model,nil);
        }else if([data[@"is"] intValue] && [data[@"msg"] intValue] == 1000){
            User *user = [Login objectOfClass:@"User" fromJSON:data[@"data"]];
            [Login doLogin:data[@"data"]];
            block(user,nil);
        }else{
            block(nil,nil);
        }
        
        
    }];
}

- (void)request_OpenIDOAuthLoginWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            User *user = [Login objectOfClass:@"User" fromJSON:data[@"data"]];
            if (user) {
                block(data[@"data"],nil);
            }
        }else{
            block(nil,nil);
        }
        
    }];
}

- (void)request_MesssgeCodeWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            block(data[@"is"],nil);
        }else{
            block(nil,nil);
        }
        
    }];
}

-(void)request_UserRegisterWithMyLogin:(Login *)login Block:(void (^)(id data, NSError *error))block{
    
    
    if (!login.icon) {
        login.urlhead = @"/upload/2018/01/23/115400001.jpg";
    }
    //发送注册 block
    void (^sendRegisterBlock)(void) = ^{
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[login toPath] withParams:[login toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            
            if ([data[@"is"] intValue]) {
                //                block(data[@"is"],nil);
                block(data[@"data"],nil);
            }else{
                block(nil,nil);
            }
        }];
    };
    
    if (login.urlhead && login.urlhead.length > 0) {
        sendRegisterBlock();
        return;
    }
    
    [self request_UpdateUserIconImage:login.icon successBlock:^(id responseObj) {
        if (responseObj) {
            login.urlhead = responseObj[@"halfpath"];
            sendRegisterBlock();
        }
        
    } failureBlock:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    
}



- (void)request_UpdateUserIconImage:(UIImage *)image
                       successBlock:(void (^)(id responseObj))success
                       failureBlock:(void (^)(NSError *error))failure
                      progerssBlock:(void (^)(CGFloat progressValue))progress{
    if (!image) {
        [NSObject showHudTipStr:@"头像不能为空"];
        if (failure) {
            failure(nil);
        }
        return;
    }
    CGSize maxSize = CGSizeMake(600, 600);
    if (image.size.width > maxSize.width || image.size.height > maxSize.height) {
        //        image = [image scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
    }
    [[TiHouseNetAPIClient sharedJsonClient] uploadImage:image path:@"api/outer/upload/uploadfile" name:@"icon" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        if (responseObject) {
            success(responseObject);
        }else{
            success(nil);
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        success(nil);
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
}



#pragma mark -- Addres
-(void)request_AddresWith:(AddresManager *)addres Block:(void (^)(id data, NSError *error))block{
    
    if (!addres) {
        return;
    }
    __block NSArray *dataArr;
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[addres toPath] withParams:[addres toParams] withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            switch (addres.GoToAddres) {
                case GoToPathTypeProvince:
                    dataArr = [Province mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    break;
                case GoToPathTypeCity:
                    dataArr = [City mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    break;
                case GoToPathTypeRegion:
                    dataArr = [Region mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    break;
                default:
                    break;
            }
            
            block(dataArr, nil);
        }else{
            block(nil, nil);
        }
    }];
    
}


#pragma mark -- House
-(void)request_HousePageWithpageHouses:(Houses *)houses Block:(void (^)(id data, NSError *error))block{
    houses.isLoading = YES;
    if (!houses) {
        return;
    }
    __block NSArray *dataArr;
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[houses toPath] withParams:[houses toParams] withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        houses.isLoading = NO;
        if (data[@"data"]) {
            dataArr = [House mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(dataArr, nil);
        }else{
            block(nil, error);
        }
    }];
    
}

-(void)request_AddHouseWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block{
    if (!house) {
        return;
    }
    //发送添加房屋 block
    void (^sendRegisterBlock)(void) = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[house AddHousetoParams]];
        [dic removeObjectForKey:@"houseid"];
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/house/add" withParams:dic withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if (data[@"is"]) {
                House *house = [House mj_objectWithKeyValues:data[@"data"]];
                block(house, nil);
            }else{
                block(nil, nil);
            }
        }];
    };
    if (!house.front && !house.back) {
        sendRegisterBlock();
    }
    if (house.front || house.back) {
        //头像
        if ((house.front && house.halfurlfront.length<=0)) {
            [[TiHouseNetAPIClient sharedJsonClient] uploadImage:house.front path:@"api/outer/upload/uploadfile" name:@"front" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                if (responseObject) {
                    house.halfurlfront = responseObject[@"halfpath"];
                    if (house.halfurlback.length>0 || !house.back) {
                        sendRegisterBlock();
                    }
                }else{
                    block(nil,nil);
                }
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            } progerssBlock:^(CGFloat progressValue) {
            }];
        }else if((house.halfurlfront.length>0 && !house.back) || (house.halfurlfront.length>0 && house.halfurlback.length>0)){
            sendRegisterBlock();
            return;
        }
        //背景
        if ((house.back && house.halfurlback.length<=0)) {
            [[TiHouseNetAPIClient sharedJsonClient] uploadImage:house.back path:@"api/outer/upload/uploadfile" name:@"back" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                if (responseObject) {
                    house.halfurlback = responseObject[@"halfpath"];
                    if (house.halfurlfront.length > 0 || !house.front) {
                        sendRegisterBlock();
                    }
                }else{
                    block(nil,nil);
                }
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            } progerssBlock:^(CGFloat progressValue) {
            }];
        }else if((house.halfurlback.length>0 && !house.front) || (house.halfurlback.length>0 && house.halfurlfront.length>0)){
            sendRegisterBlock();
        }
    }
}
-(void)request_EditHouseWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block{
    if (!house) {
        return;
    }
    //发送添加房屋 block
    __block typeof(house) blockhouse = house;
    void (^sendRegisterBlock)(void) = ^{
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/house/edit" withParams:[house AddHousetoParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue] == 1) {
                House *housea = [House mj_objectWithKeyValues:data[@"data"]];
                blockhouse.urlback = housea.urlback;
                blockhouse.urlfront = housea.urlfront;
            }
            block(data, error);
        }];
    };
    if (!house.front && !house.back) {
        sendRegisterBlock();
    }
    if (house.front || house.back) {
        //头像
        if ((house.front && house.halfurlfront.length<=0)) {
            [[TiHouseNetAPIClient sharedJsonClient] uploadImage:house.front path:@"api/outer/upload/uploadfile" name:@"front" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                if (responseObject) {
                    house.halfurlfront = responseObject[@"halfpath"];
                    if (house.halfurlback.length>0 || !house.back) {
                        sendRegisterBlock();
                    }
                }else{
                    block(nil,nil);
                }
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            } progerssBlock:^(CGFloat progressValue) {
            }];
        }else if((house.halfurlfront.length>0 && !house.back) || (house.halfurlfront.length>0 && house.halfurlback.length>0)){
            sendRegisterBlock();
            return;
        }
        //背景
        if ((house.back && house.halfurlback.length<=0)) {
            [[TiHouseNetAPIClient sharedJsonClient] uploadImage:house.back path:@"api/outer/upload/uploadfile" name:@"back" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                if (responseObject) {
                    house.halfurlback = responseObject[@"halfpath"];
                    if (house.halfurlfront.length > 0 || !house.front) {
                        sendRegisterBlock();
                    }
                }else{
                    block(nil,nil);
                }
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            } progerssBlock:^(CGFloat progressValue) {
            }];
        }else if((house.halfurlback.length>0 && !house.front) || (house.halfurlback.length>0 && house.halfurlfront.length>0)){
            sendRegisterBlock();
        }
    }
}

-(void)request_HouseInfoWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"is"]) {
            House *house = [House mj_objectWithKeyValues:data[@"data"]];
            block(house, nil);
        }
    }];
}


- (void)request_ResetCodeinviteWithHouseid:(NSInteger)houseid Block:(void (^)(id data, NSError *error))block{
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/house/resetCodeinvite" withParams:@{@"houseid":@(houseid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        House *model = [House mj_objectWithKeyValues:data[@"data"]];
        block(model,nil);
    }];
}

#pragma mark -- Houseperson
- (void)request_HousepersonWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            Houseperson *model = [Houseperson mj_objectWithKeyValues:data[@"data"]];
            block(model,nil);
        }else{
            block(data[@"msg"],nil);
        }
    }];
}


#pragma mark -- file
- (void)request_FilesBlockWith:(House *)house Block:(void (^)(id data, NSError *error))block{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/folder/listByHouseid" withParams:@{@"houseid":@(house.houseid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray *flies = [Folder mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(flies,nil);
        }else{
            block(nil,nil);
        }
    }];
}

#pragma mark -- finders
- (void)request_FindersWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/houseperson/listByHouseid" withParams:@{@"houseid":[NSString stringWithFormat:@"%ld",house.houseid]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            //            NSArray *flies = [Folder mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(data[@"data"],nil);
        }else{
            block(nil,nil);
        }
    }];
}

#pragma mark -- Housetweet
- (void)request_addHouseTweetWithTweet:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(id data, NSError *error))block {
    //发送注册 block
    tweet.dairydesc = [tweet.dairydesc stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    void (^sendRegisterBlock)(void) = ^{
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[tweet toPath: isEdit]
                                                             withParams:[tweet toParams: isEdit]
                                                         withMethodType:Post
                                                          autoShowError:YES
                                                               andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid": data[@"data"]} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                    
                    if ([data[@"is"] intValue]) {
                        [NSObject showStatusBarSuccessStr:@"动态发送成功！"];
                        //                TimerShaft *shaft = [TimerShaft mj_objectWithKeyValues:data[@"data"][0]];
                        //                block(shaft,nil);
                        Dairy *dairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
                        block(dairy, nil);
                        
                    } else {
                        [NSObject showStatusBarSuccessStr:@"动态更新失败！"];
                        block(nil, nil);
                    }
                }];

            }else{
                [NSObject showStatusBarSuccessStr:@"动态更新失败！"];
                block(nil,nil);
            }
        }];
    };
    //开始发送
    [NSObject showStatusBarQueryStr:@"正在发送房屋动态"];
    //无图片的冒泡，直接发送
    if (tweet.images.count <= 0) {
        sendRegisterBlock();
        return;
    }
    //判断图片是否全部上传完毕，是的话就发送该冒泡 block
    BOOL (^whetherAllImagesUploadedAndSendTweetBlock)(void) = ^{
        if (tweet.isAllImagesDoneSucess) {
            sendRegisterBlock();
        }
        return tweet.isAllImagesDoneSucess;
    };
    //图片均已上传，直接发送
    if (whetherAllImagesUploadedAndSendTweetBlock()) {
        return;
    }
    //遍历上传图片
    for (TweetImage *imageItem in tweet.images) {
        
        if (imageItem.imageStr.length > 0) {
            whetherAllImagesUploadedAndSendTweetBlock();
        }else{
            if (imageItem.uploadState != TweetImageUploadStateIng) {
                [TweetImage saveImageDate:imageItem.beforeModel.creationDate ? imageItem.beforeModel.creationDate : [NSDate dateWithString:tweet.createData format:@"yyyy-MM-dd"]] ;
                
                imageItem.uploadState = TweetImageUploadStateIng;
                [self request_UpdateUserIconImage:imageItem.image successBlock:^(id responseObj) {
                    imageItem.uploadState = responseObj[@"halfpath"] ? TweetImageUploadStateSuccess: TweetImageUploadStateFail;
                    if (!responseObj[@"halfpath"]) {
                        block(nil, nil);
                    }else{
                        imageItem.imageStr = [NSString stringWithFormat:@"%@", responseObj[@"halfpath"]];
                        whetherAllImagesUploadedAndSendTweetBlock();
                    }
                } failureBlock:^(NSError *error) {
                    if (block) {
                        block(nil,error);
                    }
                } progerssBlock:^(CGFloat progressValue) {
                }];
            }
        }
    }
}

// 七牛云上传
- (void)request_addHouseTweetWithQiNiu:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(Dairy *data, NSError *error))block {
    //发送注册 block
//    if (!isEdit) {
    tweet.dairydesc = [tweet.dairydesc stringByRemovingPercentEncoding];
        tweet.dairydesc = [tweet.dairydesc stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
    void (^sendRegisterBlock)(void) = ^{
        
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[tweet toPath: isEdit]
                                                             withParams:[tweet toParams: isEdit]
                                                         withMethodType:Post
                                                          autoShowError:YES
                                                               andBlock:^(id data, NSError *error) {
            
            if ([data[@"is"] intValue]) {
                
                [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid": data[@"data"]} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                    
                    if ([data[@"is"] intValue]) {
                        [NSObject showStatusBarSuccessStr:@"动态发送成功！"];
                        //                TimerShaft *shaft = [TimerShaft mj_objectWithKeyValues:data[@"data"][0]];
                        //                block(shaft,nil);
                        Dairy *dairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
                        block(dairy, nil);

                    } else {
                        [NSObject showStatusBarSuccessStr:@"动态更新失败！"];
                        block(nil, nil);
                    }
                }];
                
            }else{
                [NSObject showStatusBarSuccessStr:@"动态更新失败！"];
                block(nil,nil);
            }
        }];
    };
    //开始发送
    [NSObject showStatusBarQueryStr:@"正在发送房屋动态"];
    //无图片的冒泡，直接发送
    if (tweet.images.count <= 0) {
        sendRegisterBlock();
        return;
    }
    //判断图片是否全部上传完毕，是的话就发送该冒泡 block
    BOOL (^whetherAllImagesUploadedAndSendTweetBlock)(void) = ^{
        if (tweet.isAllImagesDoneSucess) {
            sendRegisterBlock();
        }
        return tweet.isAllImagesDoneSucess;
    };
    //图片均已上传，直接发送
    if (whetherAllImagesUploadedAndSendTweetBlock()) {
        return;
    }
    
    // 获取七牛云token
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/upload/uploadToken" withParams:nil withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            // 遍历上传图片
            QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
            for (TweetImage *imageItem in tweet.images) {
                
                if (imageItem.imageStr.length > 0) {
                    whetherAllImagesUploadedAndSendTweetBlock();
                } else {
                    if (imageItem.uploadState != TweetImageUploadStateIng) {
                        [TweetImage saveImageDate:imageItem.beforeModel.creationDate ? imageItem.beforeModel.creationDate : [NSDate dateWithString:tweet.createData format:@"yyyy-MM-dd"]];
                        imageItem.uploadState = TweetImageUploadStateIng;
                        NSData *imageData = UIImageJPEGRepresentation(imageItem.image, 1.0);
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyy/MM/dd/HHmmssSSS";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        NSString *uid = [NSString stringWithFormat:@"%ld", [Login curLoginUserID]];
                        NSString *key = [NSString stringWithFormat:@"upload/%@/%@.jpg", uid, str];
                        [uploadManager putData:imageData key:key token: data[@"data"][@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                            imageItem.uploadState = resp[@"key"] ? TweetImageUploadStateSuccess: TweetImageUploadStateFail;
                            if (!resp[@"key"]) {
                                block(nil, nil);
                            }else{
                                imageItem.imageStr = [NSString stringWithFormat:@"/%@", resp[@"key"]];
                                whetherAllImagesUploadedAndSendTweetBlock();
                            }
                        } option:nil];
                    }
                    
                }
            }
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
    
}


// MARK: - 上传视频
- (void)request_addHouseTweetVidoWithTweet:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(id data, NSError *error))block{
//    if (!isEdit) {
    tweet.dairydesc = [tweet.dairydesc stringByRemovingPercentEncoding];
        tweet.dairydesc = [tweet.dairydesc stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
    //发送注册 block
    void (^sendRegisterBlock)(void) = ^{
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[tweet toPath: isEdit]
                                                             withParams:[tweet toParams: isEdit]
                                                         withMethodType:Post
                                                          autoShowError:YES
                                                               andBlock:^(id data, NSError *error) {
            if ([data[@"is"] boolValue]) {
                [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid": data[@"data"]} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                    
                    if ([data[@"is"] intValue]) {
                        [NSObject showStatusBarSuccessStr:@"动态发送成功！"];
                        //                TimerShaft *shaft = [TimerShaft mj_objectWithKeyValues:data[@"data"][0]];
                        //                block(shaft,nil);
                        Dairy *dairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
                        block(dairy, nil);
                        
                    } else {
                        [NSObject showStatusBarSuccessStr:@"动态更新失败！"];
                        block(nil, nil);
                    }
                }];
            }else{
                [NSObject showStatusBarErrorStr:@"动态更新失败！"];
                block(nil,nil);
            }
        }];
    };
    [NSObject showStatusBarQueryStr:@"正在发送房屋动态"];
    
    //判断是否全部上传完毕，是的话就发送该冒泡 block
    BOOL (^whetherAllImagesUploadedAndSendTweetBlock)(void) = ^{
        if (tweet.isAllImagesDoneSucess) {
            sendRegisterBlock();
        }
        return tweet.isAllImagesDoneSucess;
    };
    if (whetherAllImagesUploadedAndSendTweetBlock()) {
        return;
    }
    
    
    [tweet.url thVideoCompress:^(NSURL *assetURL) { // 视频压缩
        
        NSData *videoData = [NSData dataWithContentsOfURL:assetURL];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd/HHmmssSSS";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *uid = [NSString stringWithFormat:@"%ld", [Login curLoginUserID]];
        NSString *key = [NSString stringWithFormat:@"upload/%@/%@.mp4", uid, str];
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/upload/uploadToken" withParams:nil withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                [uploadManager putData:videoData key:key token: data[@"data"][@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    if (!resp[@"key"]) {
                        [NSObject showStatusBarErrorStr:@"视频上传失败！"];
                    } else {
                        TweetImage *imageItem = tweet.images.firstObject;
                        imageItem.imageStr = [NSString stringWithFormat:@"/%@", resp[@"key"]];
                        whetherAllImagesUploadedAndSendTweetBlock();
                    }
                    
                } option: nil];
                
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
        
    }];
}

#pragma mark -- Budget - 预算列表
-(void)request_BudgetListWithBudgets:(Budgets *)budgets Block:(void (^)(id data, NSError *error))block{
    if (!budgets) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[budgets toPath] withParams:[budgets toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        budgets.isLoading = NO;
        if (data[@"data"]) {
            NSMutableArray *datas = [Budget mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(datas, error);
        }else{
            block(nil, error);
        }
    }];
}

-(void)request_LookTransformListWithLogbudgetopes:(Logbudgetopes *)logbudgetopes Block:(void (^)(id data, NSError *error))block{
    if (!logbudgetopes) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[logbudgetopes toPath] withParams:[logbudgetopes toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        logbudgetopes.isLoading = NO;
        if (data[@"data"]) {
            NSArray *datas = [Logbudgetope mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(datas, error);
        }else{
            block(nil, error);
        }
    }];
}

-(void)request_NewBudgetWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block{
    if (!budget) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[budget NewBudgetToPath] withParams:[budget NewBudgetToParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        budget.isLoading = NO;
        if (data[@"data"]) {
            Budget *budget = [Budget mj_objectWithKeyValues:data[@"data"]];
            
            block(budget, error);
        }else{
            block(nil, error);
        }
    }];
}


-(void)request_RemoveBudgetWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block{
    if (!budget) {
        block(nil, nil);
        return;
    }
    [NSObject showStatusBarQueryStr:@"正在删除...."];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[budget RemoveBudgetToPath] withParams:[budget RemoveBudgetToParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"is"]) {
            [NSObject showStatusBarSuccessStr:@"删除成功！"];
            block(data[@"is"], error);
        }else{
            [NSObject showStatusBarErrorStr:@"删除失败！"];
            block(nil, error);
        }
    }];
}

-(void)request_BudgetproWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block{
    if (!budget) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/budgetpro/list" withParams:@{@"budgetid":@(budget.budgetid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            Budgetpro *budgetpro = [Budgetpro mj_objectWithKeyValues:data[@"data"]];
            block(budgetpro, error);
        }else{
            if ([data[@"msg"] isEqualToString:@"您没有权限查看此房屋"]) {
                block(data[@"msg"],error);
            } else {
                block(nil, error);
            }
        }
    }];
}

-(void)request_LatestBudgetWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block{
    if (!house) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/budget/getLatestByHouseid" withParams:@{@"houseid":@(house.houseid)} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            Budget *budet = [Budget mj_objectWithKeyValues:data[@"data"]];
            block(budet, error);
        }else{
            if ([data[@"msg"] isEqualToString:@"您没有权限查看此房屋"]) {
                block(data[@"msg"],error);
            } else {
                block(nil, error);
            }
        }
    }];
}

-(void)request_CopyBudgetWithBudgetpro:(Budgetpro *)budgetpro Block:(void (^)(id data, NSError *error))block{
    if (!budgetpro) {
        block(nil, nil);
        return;
    }
    Budget *budget = budgetpro.budget;
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/budget/addByCopy" withParams:@{@"budgetid":@(budget.budgetid),@"budgetname":budget.budgetname} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            Budget *budet = [Budget mj_objectWithKeyValues:data[@"data"]];
            block(budet, error);
        }else{
            block(nil, error);
        }
    }];
}

-(void)request_BudgetProEditWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block{
    if (!threeClass) {
        block(nil, nil);
        return;
    }
    [NSObject showStatusBarQueryStr:@"正在请求...."];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[threeClass EidtBudgetPortoPath] withParams:[threeClass EidtBudgetPorParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] boolValue]) {
            [NSObject showStatusBarSuccessStr:@"修改成功！"];
            block(data[@"is"], error);
        }else{
            [NSObject showStatusBarErrorStr:@"修改失败！"];
            block(nil, error);
        }
    }];
}

-(void)request_BudgetProAddWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block{
    if (!threeClass) {
        block(nil, nil);
        return;
    }
    [NSObject showStatusBarQueryStr:@"正在请求...."];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[threeClass AddBudgetPortoPath] withParams:[threeClass AddBudgetPorParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] boolValue]) {
            [NSObject showStatusBarSuccessStr:@"添加成功！"];
            BudgetThreeClass *threeClass = [BudgetThreeClass mj_objectWithKeyValues:data[@"data"]];
            block(threeClass, error);
        }else{
            [NSObject showStatusBarErrorStr:@"添加失败！"];
            block(nil, error);
        }
    }];
}

-(void)request_BudgetProRemoveWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block{
    if (!threeClass) {
        block(nil, nil);
        return;
    }
    [NSObject showStatusBarQueryStr:@"正在删除...."];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[threeClass RemoveBudgetPortoPath] withParams:[threeClass RemoveBudgetPorParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] boolValue]) {
            [NSObject showStatusBarSuccessStr:@"删除成功！"];
            block(data[@"is"], error);
        }else{
            [NSObject showStatusBarErrorStr:@"删除失败！"];
            block(nil, error);
        }
    }];
}



#pragma mark -- Budget - 时间轴首页
-(void)request_TimerShaftWithTimerTweets:(TimerTweets *)timerTweets Block:(void (^)(id data, NSInteger allCount, NSError *error))block{
    if (!timerTweets) {
        block(nil, 0, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[timerTweets toPathWithCurrentMonth] withParams:[timerTweets toParamsWithCurrentMonth] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] integerValue]) {
            NSArray * timerShaft = [TimerShaft mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (timerShaft.count) {
                block(timerShaft, [data[@"allCount"] longValue], error);
            }else{
                block(nil, [data[@"allCount"] longValue], error);
            }
        }else{
            
            if ([data[@"msg"] isEqualToString:@"您没有权限查看此房屋"]) {
                block(data[@"msg"], [data[@"allCount"] longValue], error);
            } else {
                block(nil, [data[@"allCount"] longValue], error);
            }
        }
    }];
}
-(void)request_TimerShaftMonthWithTimerTweets:(TimerTweets *)timerTweets Block:(void (^)(id data, NSError *error))block{
    if (!timerTweets) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[timerTweets toPath] withParams:[timerTweets toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if (data[@"is"]) {
            NSArray * array = data[@"data"];
            if ([array count]) {
//                TweetMonthCountS *Tweet = [TweetMonthCountS mj_objectWithKeyValues:data];
                NSArray * dataArray = [MonthDairyModel mj_objectArrayWithKeyValuesArray:data[@"data"]];

//                block(Tweet,nil);
                block(dataArray, nil);
            }else{
                block(nil,nil);
            }
        }else{
            block(nil,nil);
        }
        
    }];
}

-(void)request_TimerShaftZanWithDairyzan:(Dairyzan *)dairyzan isZan:(BOOL)isZan Block:(void (^)(id data, NSError *error))block{
    if (!dairyzan) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[dairyzan toPathisZan:isZan] withParams:[dairyzan toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"is"]) {
            Dairyzan *zan = [Dairyzan mj_objectWithKeyValues:data[@"data"]];
            block(zan, error);
        }else{
            block(nil, error);
        }
    }];
}

-(void)request_TimerShaftTweetComment:(TweetComment *)tweetComment Block:(void (^)(id data, NSError *error))block{
    if (!tweetComment) {
        block(nil, nil);
        return;
    }
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[tweetComment toPath] withParams:[tweetComment toParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"is"]) {
            TweetComment *Comment = [TweetComment mj_objectWithKeyValues:data[@"data"]];
            block(Comment, error);
        }else{
            block(nil, error);
        }
    }];
}

-(void)request_TimerShaftTweetCommentList:(modelDairy *)modelDairy Params:(NSDictionary *)Params Block:(void (^)(id data, NSError *error))block{
    if (!modelDairy) {
        block(nil, nil);
        return;
    }
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:[modelDairy toCommentPath] withParams:Params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data[@"is"]) {
            NSArray *commentList = [TweetComment mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(commentList, error);
        }else{
            block(nil, error);
        }
    }];
}

#pragma mark -- schedule
- (void)request_scheduleColorSelectBlock:(void (^)(id data, NSError *error))block {
    
    NSString * path = @"/api/inter/color/list";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray * colorList = [ColorModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(colorList, nil);
        }else{
            block(nil,nil);
        }
    }];
}

- (void)request_addScheduleSelect:(AddScheduleModel *)addScheduleModel withPath:(NSString *)path Block:(void (^)(id data, NSError *error))block {
    
    NSDictionary * param = [addScheduleModel mj_keyValues];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:param withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            block(data[@"msg"], nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

#pragma mark -- cloudrecord

- (void)request_cloudRecordListCountWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    
//    NSString * path = @"/api/inter/file/listCount";
    NSString *path = @"/api/inter/dairy/listCount";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
//            NSArray * dataArray = [CloudReListCountModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSArray * dataArray = [MonthDairyModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(dataArray, nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordListByHouseidWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    NSString * path = @"/api/inter/folder/listByHouseid";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray * dataArray = [CloudReFileListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(dataArray, nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordListCountByMonthWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
//    NSString * path = @"/api/inter/file/listCountByMonth";
    NSString *path = @"/api/inter/dairy/listThreeGroupByMonth";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
//            NSArray * dataArray = [CloudReListCountModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSArray * dataArray = [MonthDairyModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            block(dataArray, nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordCollectsWithPath:(NSString *)path withParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray * dataArray = [CloudReCollectItemModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(dataArray, nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordAddFolderWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    NSString * path = @"/api/inter/folder/add";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            block(data[@"msg"], nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordDelFolderWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    NSString * path = @"/api/inter/folder/remove";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            block(data[@"msg"], nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordDelFileWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    NSString * path = @"/api/inter/file/remove";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            block(data[@"msg"], nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

- (void)request_cloudRecordCollectFileWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block {
    
    NSString * path = @"/api/inter/file/editTypecollect";
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            block(data[@"msg"], nil);
        }else{
            [NSObject showHudTipStr:data[@"msg"]];
            block(nil, nil);
        }
    }];
}

#pragma mark - relativeAndFriend
- (void)request_RelativeAndFriendHousepersonWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray * arr = data[@"data"];
            NSMutableArray * modelArr = [NSMutableArray new];
            for(int i = 0 ; i < arr.count; i ++)
            {
                Houseperson *model = [Houseperson mj_objectWithKeyValues:data[@"data"][i]];
                [modelArr addObject:model];
            }
            
            block(modelArr,nil);
        }else{
            block(nil,nil);
        }
    }];
}

- (void)request_AdvertisementsWithPath:(NSString *)path Params:(id)params Block:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            AdvertisementsDetailDataModel *model = [AdvertisementsDetailDataModel yy_modelWithDictionary:data[@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_knowLedgeAdvertisementsWithPath:(NSString *)path Params:(id)params Block:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            KnowledgeAdvertisementsDataModel *model = [KnowledgeAdvertisementsDataModel yy_modelWithDictionary:data[@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_discoveryListWithPage:(NSInteger)page UsingBlock:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(page) forKey:@"start"];
    [dic setObject:@"20" forKey:@"limit"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assemarc/page" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            DiscoveryListDataModel *model = [DiscoveryListDataModel yy_modelWithDictionary:data[@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_assemListUsingBlock:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assem/listFive" withParams:nil withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            NSArray *model = [NSArray yy_modelArrayWithClass:[FindAssemActivityInfo class] json:[data objectForKey:@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_followSomeBodyWithUid:(NSString *)uid completedUsing:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/add" withParams:@{@"concernuid":@([Login curLoginUserID]), @"concernuidon": uid} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            block([NSNumber numberWithBool:data[@"is"]],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_unFollowSomeBodyWithUid:(NSString *)uid completedUsing:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/concern/remove" withParams:@{@"concernuid":@([Login curLoginUserID]), @"concernuidon": uid} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            block([NSNumber numberWithBool:data[@"is"]],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_myConcernDiscoveryListWithPage:(NSInteger)page usingBlock:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(page) forKey:@"start"];
    [dic setObject:@"20" forKey:@"limit"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assemarc/pageMyConcern" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            NSArray *model = [NSArray yy_modelArrayWithClass:[FindAssemarcInfo class] json:[data objectForKey:@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
    
}

- (void)request_checkSomeOnesProfileWithUid:(NSInteger)uid completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(uid) forKey:@"uidother"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user/getOther" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            PersonProfileDataModel *model = [PersonProfileDataModel yy_modelWithDictionary:data[@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_articleAndDiscoveryWithUid:(NSInteger)uid index:(NSInteger)index type:(NSInteger)type completedUsing:(void (^)(id data, NSError *error))block;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(index) forKey:@"start"];
    [dic setObject:@"20" forKey:@"limit"];
    [dic setObject:@(type) forKey:@"assemarctype"];
    [dic setObject:@(uid) forKey:@"uidother"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assemarc/pageByUidother" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            NSArray *model = [NSArray yy_modelArrayWithClass:[FindAssemarcInfo class] json:[data objectForKey:@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_deleteArticleAndPhotoWithCid:(NSInteger)cid completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(cid) forKey:@"assemarcid"];
 
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assemarc/remove" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            block([NSNumber numberWithBool:data[@"is"]],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_uploadFilesWithData:(NSData *)imageData completedUsing:(void (^)(id, NSError *))block
{
    // 获取七牛云token
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/outer/upload/uploadToken" withParams:nil withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            // 遍历上传图片
            QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy/MM/dd/HHmmssSSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *uid = [NSString stringWithFormat:@"%ld", [Login curLoginUserID]];
            NSString *key = [NSString stringWithFormat:@"upload/%@/%@.jpg", uid, str];
            [uploadManager putData:imageData key:key token: data[@"data"][@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (!resp[@"key"]) {
                    block(nil, [NSError new]);
                }else{
                    block (resp[@"key"],nil);
                }
            } option:nil];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)request_EditAssembgurlWithUrl:(NSString *)url completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:url.length > 0 ? [NSString stringWithFormat:@"/%@",url]:@"" forKey:@"assembgurl"];
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user/editAssembgurl" withParams:dic withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            block(data[@"data"][@"assembgurl"],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_unreadMessageNumberCompletedUsing:(void (^)(id, NSError *))block
{
    User *user = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/collectionmine/listByUid" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
         if (data && [data[@"is"] intValue])
         {
             NSArray *tmpData = [NSArray yy_modelArrayWithClass:[CollectionNumberListDataModel class] json:data[@"data"]];
             if (block)
             {
                 block (tmpData , nil);
             }
         }
        else
        {
            block (nil, error);
        }
    }];
}

- (void)request_collectedArticleWithIndex:(NSInteger)index completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(index) forKey:@"start"];
    [dic setObject:@"20" forKey:@"limit"];
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/assemarc/pageMycoll" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            NSArray *model = [NSArray yy_modelArrayWithClass:[FindAssemarcInfo class] json:[data objectForKey:@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_advertclickWithAdvId:(NSString *)advId type:(NSString *)advType completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:advId forKey:@"advertid"];
    [dic setObject:advType forKey:@"adverttype"];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uidclick"];
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/action/advertclick" withParams:dic withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            PersonProfileDataModel *model = [PersonProfileDataModel yy_modelWithDictionary:data[@"data"]];
            block(model,nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_checkMyProfileCompletedUsing:(void (^)(id, NSError *))block
{
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user/get" withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            [Login doLogin:data[@"data"]]; 
            block([NSNumber numberWithBool:YES],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_checkMobileHasBeenRegistedWithMobile:(NSString *)mobile completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:mobile forKey:@"mobile"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/user/isRegist" withParams:dic withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            block([NSNumber numberWithBool:YES],nil);
        }else{
            block(nil,error);
        }
    }];
}

- (void)request_myCollectedPostWithIndex:(NSInteger)index completedUsing:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@([Login curLoginUserID]) forKey:@"uid"];
    [dic setObject:@(index) forKey:@"start"];
    [dic setObject:@"20" forKey:@"limit"];
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/know/pageColl" withParams:dic withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if (data && [data[@"is"] intValue]) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[KnowModeInfo class] json:data[@"data"]];
            block(array,nil);
        }else{
            block(nil,error);
        }
    }];
}

@end

