//
//  Province.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

@property (nonatomic, assign) long provid;//省份id
@property (nonatomic, copy) NSString *provname;//省份名称
@property (nonatomic, copy) NSString *tempcode;//临时字段
@property (nonatomic, assign) BOOL isSelect;



@end
