//
//  FindAssemarcInfo.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "YAHActiveObject.h"
#import "FindAssemarcCommentInfo.h"
@class FindPhotoLabelModel;

@interface FindAssemarcFileTagJA : YAHActiveObject

@property (nonatomic, assign) NSInteger assemarcfiletagid;
@property (nonatomic, assign) NSInteger assemarcfileid;  //单图id
@property (nonatomic, assign) NSInteger assemarcfiletagtype;  //1物品2空间3风格
@property (nonatomic, assign) NSInteger assemarcfiletagside; //0左边，1右边，默认右边
@property (nonatomic, copy) NSString *assemarcfiletagcontent; //    标签内容，类型为物品时为物品名称
@property (nonatomic, copy) NSString *assemarcfiletagbrand; //品牌，类型为物品时可选
@property (nonatomic, copy) NSString *assemarcfiletagprice; //价格，类型为物品时可选
@property (nonatomic, assign) CGFloat assemarcfiletagwper;  //标签所在图片宽度占据整张图片宽度的百分比
@property (nonatomic, assign) CGFloat assemarcfiletaghper;  //标签所在图片高度占据整张图片高度的百分比

- (NSString *)combineBrandAndPrice;

@end

@interface FindAssemarcFileJA : YAHActiveObject

@property (nonatomic, assign) NSInteger assemarcfileid;
@property (nonatomic, assign) CGFloat assemarcfilew;  //
@property (nonatomic, assign) CGFloat assemarcfileh;
@property (nonatomic, copy) NSString *assemarcfileurl;
@property (nonatomic, assign) BOOL assemarcfileiscoll;
@property (nonatomic, copy  ) NSString *assemarcfileurlshare;
@property (nonatomic, strong) NSArray<FindAssemarcFileTagJA *> *assemarcfiletagJA;  //标签

@end

@interface FindAssemarcInfo : YAHActiveObject

@property (nonatomic, assign) long assemarcid;
@property (nonatomic, assign) long assemarcuid;  //所属用户uid
@property (nonatomic, copy) NSString *urlindex;  //(文章)封面图片url，以/upload开头
@property (nonatomic, copy) NSString *assemarccontent; //图文内容，用html标签的形式
@property (nonatomic, assign) NSInteger assemarctype; //征集图文类型，1文章2图片
@property (nonatomic, assign) NSInteger assemarcnumzan; //点赞人数
@property (nonatomic, assign) NSInteger assemarcnumcomm; //评论条数
@property (nonatomic, assign) NSInteger assemarcnumcoll; //收藏个数
@property (nonatomic, assign) NSInteger assemarcstatus; //征集图文审核状态，0未审核1审核通过
@property (nonatomic, assign) BOOL assemarciscoll; //是否收藏 0 否 1 是
@property (nonatomic, assign) BOOL assemarciszan;  //是否点赞 0 否 1 是
@property (nonatomic, assign) BOOL assemarcisconcern;  //是否关注 0 否 1 是
@property (nonatomic, strong) NSArray<FindAssemarcCommentInfo *> *listModelAssemarccomm;   //评论列表
@property (nonatomic, copy) NSString *urlhead;  //所属用户头像
@property (nonatomic, copy) NSString *username;  //所属用户名称
@property (nonatomic, copy) NSString *assemarcfiletagJson;  //文件标签json串
@property (nonatomic, copy) NSString *assemarctitle;     //征集图文标题
@property (nonatomic, copy) NSString *assemarctitlesub; //标题说明
@property (nonatomic, assign) CGFloat assemarcpicwidth;  //封面图片宽度
@property (nonatomic, assign) CGFloat assemarcpicheigh;   //封面图片高度(类型为图片的文章才有值)，其余默认0
@property (nonatomic, copy) NSString *assemtitle;  //所属征集活动标题
@property (nonatomic, assign) long assemid;  //所属征集活动id
@property (nonatomic, copy) NSString *createtimeStr; //字符串类型的时间
@property (nonatomic, strong) NSArray<FindAssemarcFileJA *> *assemarcfileJA;
@property (nonatomic, copy  ) NSString *urlshare;
@property (nonatomic, copy  ) NSString *linkshare;

#warning 别的模块使用，  后期删除
@property (nonatomic, copy) NSString *urlsoulfilearr;  //征集图片地址 以,隔开
- (NSDictionary<NSString *, NSArray<FindPhotoLabelModel *> *> *)getLabelsDictionary;

//本地属性
@property (nonatomic, assign) BOOL isFullText; //是否显示全文
//是否超过4行
@property (nonatomic, assign) BOOL isMoreFourLine;

@end
