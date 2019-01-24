//
//  MixStringStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixStringStrategy.h"

@implementation MixStringStrategy

+ (BOOL)isAlphaNum:(NSString *)string {
    NSString *regex =@"[a-zA-Z0-9_]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
    
}

@end
