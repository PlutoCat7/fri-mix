//
//  PackIpaStrategy.m
//  CJMix
//
//  Created by wangsw on 2019/3/21.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "PackIpaStrategy.h"
#import "MixConfig.h"

@implementation PackIpaStrategy

+ (void)pack_ipa {
    
    //执行打包程序
    NSTask *task = [[NSTask alloc]init];
    [task setLaunchPath: @"/bin/sh"];
    NSString *cmdPath = [[MixConfig sharedSingleton].argvFolderPath stringByAppendingPathComponent:@"ipaConfig/pack_ipa"];
    NSString *commandStr = [NSString stringWithFormat:@"open %@",cmdPath];
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",commandStr,nil];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    [task launch];
}

@end
