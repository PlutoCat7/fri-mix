//
//  ResourceRequest.h
//  GB_TransferMarket
//
//  Created by 王时温 on 2016/12/29.
//  Copyright © 2016年 gxd. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "UserImageUploadResponeInfo.h"

@interface ResourceRequest : BaseNetworkRequest

/**
 * 用户头像上传
 */
+ (void)uploadUserPhoto:(UIImage *)image handler:(RequestCompleteHandler)handler;


@end
