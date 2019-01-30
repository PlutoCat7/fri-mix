//
//  MatchUploadPhotoResponse.h
//  GB_Football
//
//  Created by yahua on 2017/10/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface MatchUploadPhotoInfo : YAHActiveObject

@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *image_uri;

@end

@interface MatchUploadPhotoResponse : GBResponseInfo

@property (nonatomic, strong) MatchUploadPhotoInfo *data;

@end
