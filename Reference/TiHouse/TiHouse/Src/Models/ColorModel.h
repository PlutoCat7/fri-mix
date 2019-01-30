//
//  ColorModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorModel : NSObject

@property (nonatomic, assign) long colorid;//颜色id
@property (copy, nonatomic) NSString * colorvalue;//颜色值，6位大写字符，如DE23CB

@end
