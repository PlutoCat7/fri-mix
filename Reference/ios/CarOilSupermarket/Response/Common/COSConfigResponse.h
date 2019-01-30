//
//  COSConfigResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/22.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

//注册时的用户类型信息  会员客户、  批发商
@interface COSConfigMemberInfo : YAHActiveObject

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *name;

@end

@interface COSConfigInfo : YAHDataResponseInfo

@property (nonatomic, copy) NSString *agreement;  //用户协议
@property (nonatomic, copy) NSString *serviceNumber; //客服电话
@property (nonatomic, strong) NSArray<COSConfigMemberInfo *> *memberGroup;

@end

@interface COSConfigResponse : COSResponseInfo

@property (nonatomic, strong) COSConfigInfo *data;;

@end
