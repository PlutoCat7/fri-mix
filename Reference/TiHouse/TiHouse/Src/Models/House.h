//
//  House.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

//房屋id    ,县区id(关联region表)     ,创建者用户uid      ,默认文件夹id,
@property (nonatomic, assign) long houseid ,regionid ,uidcreater, defaultfoldid;
//房屋名称   ,小区  ，详址，  邀请码(大写A-Z)+8位随机数字，唯一  ,房屋头像图片地址   ,房屋背景图片地址   ,与房屋关系昵称   ,房屋创建人姓名    ,省市区 拼接
@property (nonatomic, copy) NSString *housename ,*residentname ,*addrname ,*codeinvite ,*urlfront ,*urlback ,*nickname ,*createname, *addrdetail ,*halfurlfront ,*halfurlback;
//面积    ,室数量     ,厅数量   ,厨房数量   ,卫生间数量    ,阳台数量    ,房屋状态：1正常2已删除   ,记录条数   ,与房屋的关系    ,角色类型 1读写2只读
@property (nonatomic, assign) NSInteger area ,numroom ,numhall ,numkichen ,numtoilet ,numbalcony ,status ,numlog ,typerelation, typerole, numrecord;
//   权限                                编辑  ,  查看日记   ,  查看预算     ,查看账本      ,查看日程   ,房屋动态未读数量 ,房屋亲友未读数量 ,房屋当天日程未完成数量
@property (nonatomic, assign) NSInteger isedit ,isreaddairy ,isreadbudget ,isreadtally ,isreadschedule ,housepersonnumunreaddt ,housepersonnumunreadqy ,housepersonnumunreadrc, housepersonisstick;
@property (nonatomic, retain) UIImage *back ,*front;
@property (nonatomic, assign) BOOL edit;
// 是否自己创建
@property (nonatomic, assign) NSInteger houseisself;
// 是否有男/女主人
@property (nonatomic, assign) NSInteger househasman;
@property (nonatomic, assign) NSInteger househaswoman;
// 是否是第一次创建
@property (nonatomic, assign) BOOL isFirstCreate;
// 分享专用的https图片url
@property (nonatomic, copy) NSString *urlshare;
// 分享用出去的h5链接url
@property (nonatomic, copy) NSString *linkshare;

- (NSString *)AddHousetoPath;
- (NSDictionary *)AddHousetoParams;
-(NSString *)TipStr;

+ (instancetype)getRecordHouse;
+(void)setgetRecordWithHouseid:(long)houseid housenumrecord:(NSInteger)housenumrecord;

@end

