//
//  PointsCellModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointsCellModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, strong) UIColor *pointColor;

@end
