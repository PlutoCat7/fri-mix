//
//  RawCacheManager.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/9.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "RawCacheManager.h"
#import "UserRequest.h"
#import "CommonRequest.h"
#import "GDataXMLNode.h"

NSString *const kLastUserLoginAccountKey = @"kLastUserLoginAccountKey";

NSString *const kHasLoginKey = @"kHasLoginKey";

@implementation RawCacheManager

+ (RawCacheManager *)sharedRawCacheManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[RawCacheManager alloc] init];
    });
    return instance;
}

- (void)setUserInfo:(UserInfo *)userInfo {
    
    _userInfo = userInfo;
    [_userInfo saveCache];
}

- (void)loadCache {
    
    @try {
        self.userInfo = [UserInfo loadCache];
        [UserRequest getAreaDataWithHandler:^(id result, NSError *error) {
            AreaDataInfo *info = result;
            //是否已经下载了
            NSString *fileUrl = nil;
            if (info.version) {
                [[NSUserDefaults standardUserDefaults] stringForKey:info.version];
            }
            if (!fileUrl) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURLSessionDownloadTask *task =[[NetworkManager sharedNetworkManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info.downloadUrl]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    
                    if (!error) {
                        [[NSUserDefaults standardUserDefaults] setObject:filePath.lastPathComponent forKey:info.version];
                        [self loadAreaDataWithFilePath:filePath];
                    }
                }];
                [task resume];
                });
                
            }else {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSURL *filePath = [documentsDirectoryURL URLByAppendingPathComponent:fileUrl];
                [self loadAreaDataWithFilePath:filePath];
            }
        }];
        self.config = [COSConfigInfo loadCache];
        [CommonRequest getConfigWithHandler:nil];
    } @catch (NSException *exception) {
        
    }
}

- (void)clearLoginCache {
    
    [self.userInfo clearCache];  //清除本地缓存
    self.userInfo = nil;
}

#pragma mrak - Private

- (void)loadAreaDataWithFilePath:(NSURL *)filePath {
    
    // 读取province.xml文件
    NSMutableArray *tmpAreaList = [[NSMutableArray alloc] initWithCapacity:1];
    NSData *data=[[NSData alloc]initWithContentsOfURL:filePath];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [xmlEle children];
    //读取省
    for (int i = 0; i < [array count]; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        // 根据标签名判断
        if ([[ele name] isEqualToString:@"province"]) {
            AreaInfo *provinceObj = [[AreaInfo alloc]init];
            provinceObj.areaName = [[ele attributeForName:@"name"] stringValue];
            provinceObj.areaChidlArray = [NSMutableArray new];
            
            // 读取市
            NSArray *cityArray = [ele children];
            for (int j = 0; j < [cityArray count]; j++) {
                GDataXMLElement *cityEle = [cityArray objectAtIndex:j];
                if ([[cityEle name] isEqualToString:@"city"]) {
                    AreaInfo *cityObj = [[AreaInfo alloc] init];
                    cityObj.superAreaInfo = provinceObj;
                    cityObj.areaName = [[cityEle attributeForName:@"name"] stringValue];
                    cityObj.areaChidlArray = [NSMutableArray new];
                    [provinceObj.areaChidlArray addObject:cityObj];
                    
                    // 读取区
                    NSArray *areaArray = [cityEle children];
                    for (int m = 0; m < [areaArray count]; m++) {
                        GDataXMLElement *areaEle = [areaArray objectAtIndex:m];
                        if ([[areaEle name] isEqualToString:@"county"]) {
                            AreaInfo *areaObj = [[AreaInfo alloc] init];
                            areaObj.superAreaInfo = cityObj;
                            areaObj.areaName = [[areaEle attributeForName:@"name"] stringValue];
                            [cityObj.areaChidlArray addObject:areaObj];
                        }
                    }
                }
            }
            if ([provinceObj.areaName isEqualToString:@"请选择省份"]) {
                continue;
            }
            [tmpAreaList addObject:provinceObj];
        }
    }
    _areaList = [tmpAreaList copy];
}

#pragma mark - Setter and Getter

- (NSString *)userId {
    
    NSString *userId = self.userInfo.userId;
    if (!userId) {
        userId = @"0";
    }
    return userId;
}

- (void)setLastAccount:(NSString *)lastAccount {
    
    if ([NSString stringIsNullOrEmpty:lastAccount]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastAccount forKey:kLastUserLoginAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastAccount {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastUserLoginAccountKey];
}

- (void)setIsLastLogined:(BOOL)isLastLogined {
    
    [[NSUserDefaults standardUserDefaults] setBool:isLastLogined forKey:kHasLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLastLogined {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasLoginKey];
}


@end
