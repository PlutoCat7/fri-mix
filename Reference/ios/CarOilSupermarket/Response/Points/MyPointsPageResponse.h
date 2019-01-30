//
//  MyPointsPageResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSPageResponseInfo.h"

//"remark": "邀请用户18600000003注册",
//"prefix1": "+",
//"point": "5.00",
//"fTime": "2018-01-12"


@interface MyPointsInfo : YAHActiveObject

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *prefix1;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *fTime;

@end

@interface MyPointsPageInfo : YAHActiveObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) NSArray<MyPointsInfo *> *list;
@property (nonatomic, assign) NSInteger pages;     //总页数
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface MyPointsPageResponse : COSPageResponseInfo

@property (nonatomic, strong) MyPointsPageInfo *data;

@end
