//
//  GBBleUtility.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBBleUtility : NSObject

// 判断字符串是不是mac地址
+ (BOOL)stringIsMacAddress:(NSString *)mac;
    
@end
