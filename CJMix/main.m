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
#import "Strategy/MixMethodStrategy.h"
#import "Config/MixConfig.h"
#import "Strategy/file/MixFileNameStrategy.h"
#import "Strategy/protocol/MixProtocolStrategy.h"
#import "MixYAHCategoryStrategy.h"
#import "Strategy/category/MixYAHCategoryStrategy.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        [MixConfig sharedSingleton].shieldPaths = @[@"imkit",@"imsdk",@"FDFullscreenPopGesture",@"ThirdModule",@"FBKVOController",@"MJExtension"];
        [MixConfig sharedSingleton].shieldClass = @[@"VoiceGiftModel",@"WLPropModel",@"WLSVGBaseModel",@"LaunchAdvertItem",@"HabibiRoomSearchCellModel",@"WLSenderGiftModel",@"WLHabibiGameDefaultResultModel",@"WLSVGBaseModel",@"VoiceFreeGiftModel",@"VoiceTopupMode",@"SVGAParser",@"ResourceConfigModel",@"ResourceMedalItem",@"ResourceNobleItem",@"ResourceLevelItem",@"ResourceGiftItem",@"FriendModel",@"UserAttributeMedalItem",@"UserAttributeModel",@"ResourceConfigModel",@"BaseItem"];
        
        [MixConfig sharedSingleton].openLog = NO;


#if 1
        //NSString * referencePath = @"/Users/wangsw/wangle/majiabao/Reference";
        //NSString * rootPath = @"/Users/wangsw/wangle/majiabao/AudioRoom";
        //NSString * rootPath = @"/Users/wangsw/wangle/majiabao/najiabao-file";
        NSString * referencePath = @"/Users/wn/Desktop/Reference";
        NSString * rootPath = @"/Users/wn/Documents/git/WonderVoice/Trunk/AudioRoom";
#else
        NSString * referencePath = @"/Users/yegaofei/Desktop/ygf_project/Rongle/wangle_src/CJMix/Reference";
        NSString * rootPath = @"/Users/yegaofei/Desktop/ygf_project/Rongle/wangle_src/WonderVoice/Trunk/AudioRoom";
#endif
        
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

        NSArray <MixObject*>* referenceObjects = [MixObjectStrategy objectsForKey:@"mix_reference"];
        if (!referenceObjects) {
            referenceObjects = [MixObjectStrategy objectsWithPath:referencePath];
            [MixObjectStrategy saveObjects:referenceObjects key:@"mix_reference"];
        }
        
        printf("获取需要被替换对象\n");
        NSArray <MixObject*>* copyObjects = [MixObjectStrategy objectsWithPath:copyPath saveConfig:YES];
        
        printf("获取替换类名\n");
        NSArray <NSString *>* classNames = [MixReferenceStrategy classNamesWithObjects:referenceObjects];
        printf("开始替换类名\n");
        [MixMainStrategy replaceClassName:copyObjects referenceClassNames:classNames];
        printf("结束替换类名\n");

        printf("获取系统方法\n");
        NSArray <NSString *> * systemMethods = [MixMethodStrategy systemMethods];
        NSString * podPath = @"/Users/wn/Documents/git/WonderVoice/Trunk/AudioRoom/Pods";
        NSArray <NSString *> * podsMethods = [MixMethodStrategy methodsWithPath:podPath];
        
        NSString * thirdPath = @"/Users/wn/Documents/git/WonderVoice/Trunk/AudioRoom/AudioRoom/Classes/ThirdModule";
        NSArray <NSString *> * thirdMethods = [MixMethodStrategy methodsWithPath:thirdPath];
        
        NSMutableArray * methods = [NSMutableArray arrayWithCapacity:0];
        [methods addObjectsFromArray:systemMethods];
        [methods addObjectsFromArray:podsMethods];
        [methods addObjectsFromArray:thirdMethods];
        
        printf("获取替换方法名\n");
        NSArray <NSString *>* referenceMethods = [MixReferenceStrategy methodWithObjects:referenceObjects];
        printf("开始替换方法（请耐心等待）\n");
        [MixMainStrategy replaceMethod:copyObjects methods:referenceMethods systemMethods:methods];
        printf("结束替换方法\n");

        printf("开始替换Protocol名称\n");
        if ([MixProtocolStrategy startWithPath:rootPath]) {
            printf("替换Protocol名称成功\n");
        }else {
            printf("替换Protocol名称出错了\n");
        }
        
        printf("开始替换Category名称\n");
        if ([[MixYAHCategoryStrategy shareInstance] start]) {
            printf("替换Category名称成功\n");
        }else {
            printf("替换Category名称出错了\n");
        }

        printf("开始替换文件名称\n");
        if ([MixFileNameStrategy start:copyObjects rootPath:rootPath mixPath:copyPath]) {
            printf("替换文件名称成功\n");
        }else {
            printf("替换文件名称出错了\n");
        }
    }
    return 0;
}
