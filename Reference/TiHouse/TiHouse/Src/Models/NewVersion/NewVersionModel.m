//
//  NewVersionModel.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewVersionModel.h"
#import "Login.h"

@implementation VersionContentModel

@end

@implementation NewVersionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"versioncontentJA" : [VersionContentModel class]
             };
}

+ (void)checkNewVersion:(void (^)(BOOL, NewVersionModel *))block {
    NSInteger currentVersionNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"versionno"];
    NSDictionary *params = @{@"versionno": @(currentVersionNumber),
                             @"uid": @([Login curLoginUserID])
                             };
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/version/getLatest" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            NewVersionModel *model = [NewVersionModel mj_objectWithKeyValues:data[@"data"]];
            model.labelWidth = [model.versioncode getWidthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToSize:CGSizeMake(MAXFLOAT, 22)] + 20;
            if (model.versionno != currentVersionNumber) {
                block(TRUE, model);
                
            } else {
                block(FALSE, nil);
            }
        } else {
//            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];

}

@end
