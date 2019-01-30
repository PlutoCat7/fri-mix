//
//  TeamLogoUploadResponeInfo.h
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface TeamLogoUploadInfo : YAHActiveObject

@property (nonatomic, copy) NSString *imageUrl;

@end

@interface TeamLogoUploadResponeInfo : GBResponseInfo

@property (nonatomic, strong) TeamLogoUploadInfo *data;

@end
