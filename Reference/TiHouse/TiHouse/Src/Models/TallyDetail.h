//
//  TallyDetail.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TallyDetail : NSObject
@property (assign, nonatomic) NSInteger tallyproid; // 自增长id
@property (assign, nonatomic) NSInteger tallyid; // 所属账本id，与tally表的tallyid一致
@property (assign, nonatomic) NSInteger cateoneid; // 所属一级分类id
@property (assign, nonatomic) NSInteger catetwoid; // 所属二级分类id
@property (assign, nonatomic) NSInteger catethreeid; // 所属三级分类id
@property (strong, nonatomic) NSString *tallyprocatename; // 明细名称
@property (assign, nonatomic) NSInteger tallyprotime; // 明细时间
@property (strong, nonatomic) NSString *tallyproremark; // 明细备注
@property (strong, nonatomic) NSString *tallyprobrand; // 明细品牌
@property (strong, nonatomic) NSString *tallyproxh; // 明细型号
@property (assign, nonatomic) NSInteger tallyprotype; // 明细类型，1支出2退款
@property (strong, nonatomic) NSString *arrurlcert; // 图片或发票凭证url 多图用逗号分隔
@property (assign, nonatomic) CGFloat locationlng; // 经度(以谷歌地图为准)
@property (assign, nonatomic) CGFloat locationlat; // 纬度(以谷歌地图为准)
@property (strong, nonatomic) NSString *paywayname; // 支付途径名称
@property (strong, nonatomic) NSString *cateonename; // 所属一级分类名称
@property (strong, nonatomic) NSString *catetwoname; // 所属二级分类名称
@property (strong, nonatomic) NSString *catethreename; // 所属三级分类名称
@property (assign, nonatomic) NSInteger amountzj; // 账本项目总价，单位(分)
@property (assign, nonatomic) CGFloat doubleamountzj; // 账本项目总价，单位(元)
@property (strong, nonatomic) NSString *tallyname; // 账本名称
@property (strong, nonatomic) NSString *locationname; // 地理位置名称

#pragma mark - utils
@property (strong, nonatomic) NSArray *imageArray; // [UIImage]
@property (nonatomic) BOOL isEdit; // 是否编辑
@property (nonatomic) BOOL isSynchronDate; // 是否同步日期

- (NSDictionary *)addTallDetailtoParams;

- (NSString *)validPostParams;

@end
