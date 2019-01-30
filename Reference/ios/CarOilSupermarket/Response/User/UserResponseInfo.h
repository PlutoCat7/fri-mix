//
//  UserResponseInfo.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/9.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

//"id": "121121",// 用户唯一id
//"mobile": "18699999999",
//"fromMobile": "18688888888",  // 邀请人手机号
//"grade": "0",  // 用户等级    0-5共六个等级,  -1时不显示
//"nick": "微名字",
//"avatar": "http://头像.jpb",
//"groupName": "批发商/零售商",
//"needProfile": "1",//1是0否需要补充资料
//"point": "123",//积分
//"balance": "123",//余额
//"quanCount": "123",//代金券数量
//"canWithdraw": "1", // 1可提现0不可提现
//"serviceNumber": "400-123-1234",//客服电话


@interface UserInfo : YAHDataResponseInfo

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *groupName;   //"批发商/零售商"
@property (nonatomic, assign) BOOL needProfile;   //1是0否需要补充资料
@property (nonatomic, assign) NSInteger point;  //积分
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) NSInteger quanCount; //代金券数量
@property (nonatomic, assign) BOOL canWithdraw;
@property (nonatomic, copy) NSString *serviceNumber;
@property (nonatomic, copy) NSString *fromNumber;
@property (nonatomic, assign) NSInteger grade;

@end

@interface UserResponseInfo : COSResponseInfo

@property (nonatomic, strong) UserInfo *data;

@end
