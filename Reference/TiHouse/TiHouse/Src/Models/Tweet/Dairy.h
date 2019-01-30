//
//  Dairy.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetWHModel.h"
//#import "HouseTweet.h"

@class FileModel;
@class RangeModel;
@class RemindModel;

@interface Dairy : NSObject

//                       日记类型，1纯文本2图片3视频     可见范围类型，1仅自己2由arruidrange指定
@property (nonatomic, assign) NSInteger dairytype, dairyrangetype, housepersonnumunreaddt;
//                                自增长id  ,用户uid  ,日记记录时间,  文件夹id  ,日记创建时间
@property (nonatomic, assign) long dairyid, uid, dairytime, folderid, dairycreatetime,houseid;
//             日记文字内容,      可见范围用户uid数组，以","分割  ,  文件URL数组，以“,”分割   ,所属文件夹名称   ,提醒用户uid数组，以","分割     ,略缩图,房屋名称,用户名
@property (nonatomic, copy) NSString *dairydesc, *arruidrange,  *arrurlfile,  *foldername,  *arruidremind, *housename, *nickname;

//@property (nonatomic, copy) NSString *urlfilesmall; // 待废弃：图片视频略缩图地址","拼接
@property (nonatomic, strong) NSArray *urlfilesmallArr; // 待废弃：1.图片视频略缩图地址 2.发状态时本地构造TweetImage对象

//                                 可见范围用户uid数组  ,  文件URL数组   ,   提醒用户uid数组
@property (nonatomic, retain) NSArray *arruidrangeArr,  *arrurlfileArr,  *arruidremindArr;

@property (nonatomic, strong) NSMutableArray *dairysmallfileinfoJA;

@property (nonatomic, assign) NSInteger dairytimetype;

@property (nonatomic, copy) NSString *urlshare, *linkshare;
//
@property (nonatomic, strong) NSMutableArray<RangeModel *> *dairyrangeJA;
@property (nonatomic, strong) NSMutableArray<FileModel *> *fileJA;
@property (nonatomic, strong) NSMutableArray<RemindModel *> *dairyremindJA;

@property (nonatomic, assign) long createtime;

@property (nonatomic, assign) long diytime;

-(Dairy *)transformDairy;

// 判断是否显示全文，默认否
@property (nonatomic, assign) BOOL isFullText;


@end
