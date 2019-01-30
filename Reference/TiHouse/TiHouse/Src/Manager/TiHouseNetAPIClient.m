//
//  TiHouseNetAPIClient.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "TiHouseNetAPIClient.h"
#import "LoginViewController.h"
#import "NSObject+Common.h"
#import "Login.h"
#import "RootTabViewController.h"
static int NUCODE = 0;
@implementation TiHouseNetAPIClient


static TiHouseNetAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;
+(TiHouseNetAPIClient *)sharedJsonClient{
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TiHouseNetAPIClient alloc]initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    });
    return _sharedClient;
}

+ (id)changeJsonClient{
    _sharedClient = [[TiHouseNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block{
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block{
    if (!aPath || aPath.length <= 0) {
        return;
    }
    params = [self encrypt:params];
    //CSRF - 跨站请求伪造
    NSHTTPCookie *_CSRF = nil;
    for (NSHTTPCookie *tempC in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([tempC.name isEqualToString:@"XSRF-TOKEN"]) {
            _CSRF = tempC;
        }
    }
    if (_CSRF) {
        [self.requestSerializer setValue:_CSRF.value forHTTPHeaderField:@"X-XSRF-TOKEN"];
    }
    //log请求数据
    XWLog(@"\n===========request===========\n%@:\n%@",aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    发起请求
    
    //    头信息加入
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"versionno"] forHTTPHeaderField:@"versionno"];
    [self.requestSerializer setValue:@"1" forHTTPHeaderField:@"terminal"];
    NSString *screenSize = [NSString stringWithFormat:@"%.2lfX%.2lf",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height];
    [self.requestSerializer setValue:screenSize forHTTPHeaderField:@"screenSize"];
    
    
    switch (method) {
        case Get:{
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                XWLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                if (![responseObject[@"is"] integerValue]) {
                    if ([responseObject[@"msg"] isEqualToString:@"签名有误"]) {
                        if (NUCODE == 0) {
                            NUCODE = 1;
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号可能其他地方登录，请重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
                            [Login doLogout];
                            AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                            [appledate setRootViewController];
                            [alert show];
                        }
                        return ;
                    }
                    [NSObject showHudTipStr:responseObject[@"msg"]];
                }
                NUCODE = 0;
                block(responseObject, nil);
                if (![responseObject[@"is"] integerValue] && autoShowError) {
                    [NSObject showHudTipStr:responseObject[@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !autoShowError || [NSObject showError:error];
                if (error.userInfo[@"NSLocalizedDescription"] == @"似乎已断开与互联网的连接。") {
                    [NSObject showHudTipStr:@"似乎已断开与互联网的连接。"];
                }
//                id responseObject = [NSObject loadResponseWithPath:localPath];
                NSLog(@"===========response=========%@", error);
                block(nil, error);
            }];
            break;}
        case Post:{
            
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"code"] integerValue] == 10000) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"DeleteByCreator"];                    
                    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您关注的房屋信息已被主人删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        RootTabViewController *rootVC = [[RootTabViewController alloc] init];
                        rootVC.tabBar.translucent = YES;
                        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                                                                     }];
                    [alertVC addAction:cancel];
                    [rootVC presentViewController:alertVC animated:YES completion:nil];
                    return;
                }
                
                XWLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                if (![responseObject[@"is"] integerValue] && autoShowError) {
                    XWLog(@"===sdfg========%d",NUCODE);
                    if ([responseObject[@"msg"] isEqualToString:@"签名有误"]) {
                        if (NUCODE == 0) {
                            NUCODE = 1;
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号可能其他地方登录，请重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
                            [Login doLogout];
                            AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                            [appledate setRootViewController];
                            [alert show];
                        }
                        return ;
                    }
                    [NSObject showHudTipStr:responseObject[@"msg"]];
                }
                NUCODE = 0;
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (error.userInfo[@""]) {
                    [NSObject showHudTipStr:@"似乎已断开与互联网的连接。"];
                }
                block(nil, error);
            }];
            break;}
        case Put:{
            
            break;}
        case Delete:{
   
            break;}
        default:
            break;
    }
    
}

-(NSDictionary *)encrypt:(NSDictionary *)parameters{
    
    //获取时间戳差
//    NSString *difference = [RKBUserDefaults getTimeDifference];
//    long long difference_int = [difference longLongValue];
//    RKBLog(@"时间差%lld",difference_int);
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *systemDateStr = [NSString stringWithFormat:@"%.0f",[dat timeIntervalSince1970]*1000];
    long long  systemDate = [systemDateStr longLongValue];
    
    //结算时间戳
    //   按理来说这样的         long long finallyDate =  systemDate + difference_int;
    long long finallyDate =  systemDate;
    
    //            NSDictionary *dic = parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([Login curLoginUser]) {
        User *user = [Login curLoginUser];
        [parameters setValue:[NSString stringWithFormat:@"%ld",user.uid] forKey:@"uid"];
    }else{
        [parameters setValue:@(-1) forKey:@"uid"];
    }
    [parameters setValue:[NSString stringWithFormat:@"%lld",finallyDate] forKey:@"time_"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
        [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"devicetoken_"];
    }
    //字典转数组
    NSMutableArray *parametersArr = [NSMutableArray array];
    NSMutableArray *valuesArr = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [parametersArr addObject:key];
        
    }];
    //排序key
    NSArray *sortArrAscendingKey = [parametersArr sortedArrayUsingSelector:@selector(compare:)];
    //遍历值
    [sortArrAscendingKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *value = [NSString stringWithFormat:@"%@",[parameters objectForKey:obj]];
        [valuesArr addObject:value];
        
    }];
    
    
    //拼接字符串排序参数
    NSString *url;
    for (int i = 0; i<sortArrAscendingKey.count; i++) {
        if (i==0) {
            
            url = [NSString stringWithFormat:@"%@=%@",sortArrAscendingKey[i],valuesArr[i]];
            
        }else{
            url = [NSString stringWithFormat:@"%@&%@=%@",url,sortArrAscendingKey[i],valuesArr[i]];
        }
        
    }
    //需要排序参数
    //            NSString *url = [NSString stringWithFormat:@"passwordNew=%d&passwordOld=%d&time_=%ld&uid=%@",100861,111111,(long)ww,[RKBUserDefaults getUserID]];
    User *user = [Login curLoginUser];
    NSString *urlfor = [NSString stringWithFormat:@"%@&key_=^d0@fgajk'z9&token_=%@",url,user.token];
    //md5加密后的字符串
    NSString *sign = [[urlfor md5Str] uppercaseString];
    [parameters setValue:sign forKey:@"sign_"];
    
    return parameters;
}


- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress{
    
    NSData *data = [image dataForCodingUpload];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *nameStr = [NSString stringWithFormat:@"%@%@.jpg",name,str];
    XWLog(@"\n===========request===========\n%@:\n%@",path, name);
    [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"fileStream" fileName:nameStr mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat i = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
        if (progress) {
            progress(i);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XWLog(@"======%@",responseObject);
        if (success) {
            if ([responseObject[@"is"] integerValue]) {
                success(task,responseObject[@"data"]);
                return;
            }
            success(task,nil);
            [NSObject showHudTipStr:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XWLog(@"======%@",error);
        if (failure) {
            failure(task,error);
        }
    }];
}


- (void)uploadVideoData:(NSData *)data successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
           failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
          progerssBlock:(void (^)(CGFloat progressValue))progress{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
    [self POST:@"api/outer/upload/uploadfile" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"fileStream" fileName:str mimeType:@"mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat i = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
        if (progress) {
            progress(i);
        }
        XWLog(@"========%f",i);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XWLog(@"======%@",responseObject);
        if (success) {
            if ([responseObject[@"is"] integerValue]) {
                success(task,responseObject[@"data"]);
                return;
            }
            success(task,nil);
            [NSObject showHudTipStr:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

@end
