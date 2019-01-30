//
//  Advert.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advert : NSObject

//id
@property (nonatomic, assign) long advertid;
//广告封面，以/upload开头的半路径
@property (nonatomic, retain) NSString *urlpicindex;
//类型，1H5链接2发现的详情页3知识的详情页4商城的首页5商城的商品详情页
@property (nonatomic, assign) NSInteger type;
//显示状态，0不显示1显示
@property (nonatomic, assign) NSInteger statusshow;
//H5广告链接全路径
@property (nonatomic, retain) NSString *allurllink;
//非H5类型时，对应内容的id
@property (nonatomic, assign) long contentid;

@end
