//
//  GBBleUtility.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBBleUtility.h"

@implementation GBBleUtility

+ (BOOL)stringIsMacAddress:(NSString *)mac {
    NSString * macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",macAddRegex];
    return [pre evaluateWithObject:mac];
}
    
@end
