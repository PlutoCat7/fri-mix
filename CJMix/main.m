//
//  main.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model/MixObject.h"
#import "Model/MixFile.h"
#import "Strategy/MixFileStrategy.h"
#import "Strategy/MixClassFileStrategy.h"
#import "Strategy/MixObjectStrategy.h"
#import "Strategy/MixMainStrategy.h"
#import "Strategy/MixReferenceStrategy.h"
#import "Config/MixConfig.h"
#import "Strategy/MixFileNameStrategy.h"
#import "Strategy/MixProtocolStrategy.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        [MixConfig sharedSingleton].shieldPaths = @[@"imkit",@"imsdk",@"FDFullscreenPopGesture",@"ThirdModule",@"FBKVOController",@"MJExtension"];
        [MixConfig sharedSingleton].shieldClass = @[@"VoiceGiftModel",@"WLPropModel",@"WLSVGBaseModel",@"LaunchAdvertItem",@"HabibiRoomSearchCellModel",@"WLSenderGiftModel",@"WLHabibiGameDefaultResultModel",@"WLSVGBaseModel",@"VoiceFreeGiftModel",@"VoiceTopupMode",@"SVGAParser",@"ResourceConfigModel",@"ResourceMedalItem",@"ResourceNobleItem",@"ResourceLevelItem",@"ResourceGiftItem",@"FriendModel",@"UserAttributeMedalItem",@"UserAttributeModel",@"ResourceConfigModel",@"BaseItem"];
        
        [MixConfig sharedSingleton].openLog = NO;


        NSString * referencePath = @"/Users/wangsw/wangle/majiabao/Reference";
        //NSString * rootPath = @"/Users/wangsw/wangle/majiabao/najiabao-file";
        NSString * rootPath = @"/Users/wangsw/wangle/majiabao/AudioRoom";
        

        
        
//        NSString * referencePath = @"/Users/wn/Desktop/Reference";
//        NSString * rootPath = @"/Users/wn/Documents/git/WonderVoice/Trunk/AudioRoom";
  
//        NSString * referencePath = @"/Users/wn/Documents/git/CJMix/Demo1";
//        NSString * rootPath = @"/Users/wn/Documents/git/CJMix/Demo2";
        
        
        NSString * copyPath = [NSString stringWithFormat:@"%@_mix",rootPath];
        
        NSString * sdkPath = @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform";

        
        printf("拷贝文件中..\n");
        BOOL isSuccess = [MixFileStrategy copyItemAtPath:rootPath toPath:copyPath overwrite:YES error:nil];
        if (!isSuccess) {
            printf("拷贝文件失败\n");
            return 0;
        }
        printf("拷贝文件成功\n");
        printf("获取替换对象\n");
        NSArray <MixObject*>* referenceObjects = [MixObjectStrategy objectsWithPath:referencePath];
        printf("获取需要被替换对象\n");
        NSArray <MixObject*>* copyObjects = [MixObjectStrategy objectsWithPath:copyPath saveConfig:YES];
        printf("获取替换类名\n");
        NSArray <NSString *>* classNames = [MixReferenceStrategy classNamesWithObjects:referenceObjects];
        printf("开始替换类名\n");
        [MixMainStrategy replaceClassName:copyObjects referenceClassNames:classNames];
        printf("结束替换类名\n");
        
        
        printf("获取系统对象\n");
//        NSArray <MixObject*>* systemObjects = [MixObjectStrategy objectsWithPath:sdkPath];
        NSArray <MixObject*>* systemObjects = nil;
        if (![MixConfig sharedSingleton].systemObjects) {
            systemObjects = [MixObjectStrategy objectsWithPath:sdkPath];
            [MixConfig sharedSingleton].systemObjects = systemObjects;
        } else {
            systemObjects = [MixConfig sharedSingleton].systemObjects;
        }
        
        
//        printf("获取替换方法名\n");
//        NSArray <NSString *>* referenceMethods = [MixReferenceStrategy methodWithObjects:referenceObjects];
//        printf("开始替换方法（请耐心等待）\n");
//        [MixMainStrategy replaceMethod:copyObjects methods:referenceMethods systemObjects:systemObjects];
//        printf("结束替换方法\n");
        
        

        printf("开始替换Protocol名称\n");
        if ([MixProtocolStrategy start]) {
            printf("替换Protocol名称成功\n");
        }else {
            printf("替换Protocol名称出错了\n");
        }
        
        printf("开始替换文件名称\n");
        if ([MixFileNameStrategy start:copyObjects rootPath:rootPath]) {
            printf("替换文件名称成功\n");
        }else {
            printf("替换文件名称出错了\n");
        }

    }
    return 0;
}
