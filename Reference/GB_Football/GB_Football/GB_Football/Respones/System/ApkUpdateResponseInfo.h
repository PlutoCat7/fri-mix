//
//  ApkUpdateResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface ApkUpdateInfo : YAHActiveObject

@property (nonatomic, copy) NSString *apkUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isForce;

@end

@interface ApkUpdateResponseInfo : GBResponseInfo

@property (nonatomic, strong) ApkUpdateInfo  *data;

@end
