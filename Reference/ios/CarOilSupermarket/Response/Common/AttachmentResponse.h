//
//  AttachmentResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/19.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface AttachmentInfo : YAHActiveObject

@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *attachmentId;

@end

@interface AttachmentResponse : COSResponseInfo

@property (nonatomic, strong) AttachmentInfo *data;

@end
