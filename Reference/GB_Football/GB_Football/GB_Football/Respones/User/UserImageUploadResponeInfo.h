//
//  UserImageUploadResponeInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface UserImageUploadInfo : YAHActiveObject

@property (nonatomic, copy) NSString *imageUrl;

@end

@interface UserImageUploadResponeInfo : GBResponseInfo

@property (nonatomic, strong) UserImageUploadInfo *data;

@end
