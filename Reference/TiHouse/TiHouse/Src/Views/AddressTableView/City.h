//
//  City.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, assign) long cityid;//城市id
@property (nonatomic, copy) NSString *cityname;//城市名称
@property (nonatomic, assign) long provid;//所属省份provid
@property (nonatomic, copy) NSString *tempcode;
@property (nonatomic, assign) BOOL isSelect;

@end
