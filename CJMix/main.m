//
//  main.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config/MixConfig.h"
#import "Model/MixObject.h"
#import "Model/MixFile.h"
#import "Strategy/MixFileStrategy.h"
#import "Strategy/MixClassFileStrategy.h"
#import "Strategy/MixObjectStrategy.h"
#import "Strategy/MixMainStrategy.h"
#import "Strategy/MixReferenceStrategy.h"
#import "Strategy/MixMethodStrategy.h"
#import "Strategy/MixStringStrategy.h"
#import "Strategy/file/MixFileNameStrategy.h"
#import "Strategy/protocol/MixProtocolStrategy.h"
#import "Strategy/category/MixYAHCategoryStrategy.h"
#import "MixDefine.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        MixLog(@"欢迎使用CJMix （BUG请联系467116811@qq.com 与 yahua523@163.com）\n");
        
        NSString * argvPath = [NSString stringWithFormat:@"%s",*argv];
        NSString * argvFolderPath = argvPath.stringByDeletingLastPathComponent;
        NSString * mixPlistPath = [NSString stringWithFormat:@"%@/mix.plist",argvFolderPath];
        
        if ([MixFileStrategy isExistsAtPath:mixPlistPath]) {
            MixLog(@"偶遇mix.plist文件\n");
        } else {
            MixLog(@"丢失mix.plist文件！请输入路径：\n");
//            char a[1000];
//            scanf("%s",a);
//            mixPlistPath = [NSString stringWithFormat:@"%s", a];
            mixPlistPath = @"/Users/wn/Documents/mix.plist";
            if (![MixFileStrategy isExistsAtPath:mixPlistPath]) {
                MixLog(@"文件不存在\n");
                return 0;
            }
        }
        
        [MixConfig sharedSingleton].argvFolderPath = argvFolderPath;
        [MixConfig sharedSingleton].mixPlistPath = mixPlistPath;
        
        NSString * referencePath = [MixConfig sharedSingleton].referencePath;
        NSString * rootPath = [MixConfig sharedSingleton].rootPath;
        NSString * copyPath = [NSString stringWithFormat:@"%@_%@",rootPath,[MixConfig sharedSingleton].mixPrefix];
        
        if (!referencePath || !rootPath) {
            MixLog(@"请检查配置\n");
            return 0;
        }

        MixLog(@"拷贝文件中..\n");
        BOOL isSuccess = [MixFileStrategy copyItemAtPath:rootPath toPath:copyPath overwrite:YES error:nil];
        if (!isSuccess) {
            MixLog(@"拷贝文件失败\n");
            return 0;
        }
        MixLog(@"拷贝文件成功\n");
        
        
        MixLog(@"获取需要被替换对象\n");
        NSArray <MixObject*>* copyObjects = [MixObjectStrategy objectsWithPath:copyPath saveConfig:YES];
        MixLog(@"获取替换对象\n");
        NSArray <MixObject*>* referenceObjects = [MixObjectStrategy objectsWithPath:referencePath];
        MixLog(@"获取替换类名\n");
        NSArray <NSString *>* classNames = [MixReferenceStrategy classNamesWithObjects:referenceObjects];
        MixLog(@"开始替换类名\n");
        [MixMainStrategy replaceClassName:copyObjects referenceClassNames:classNames];
        MixLog(@"结束替换类名\n");
        
        MixLog(@"获取框架方法名\n");
        NSMutableArray * frameworkMethods = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * frameworkPaths = [NSMutableArray arrayWithArray:[MixConfig sharedSingleton].frameworkPaths];
        NSString * systemPaths = @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform";
        [frameworkPaths addObject:systemPaths];

        for (NSString * framework in frameworkPaths) {
            NSArray <NSString *> * methods = [MixMethodStrategy methodsWithPath:framework];
            [frameworkMethods addObjectsFromArray:methods];
        }
        if (!frameworkMethods.count) {
            MixLog(@"没有发现框架方法名\n");
        }
        
        MixLog(@"获取替换方法名\n");
        NSArray <NSString *> * methods = [MixMethodStrategy methodsWithPath:referencePath];
        NSArray <NSString *>* referenceMethods = [MixReferenceStrategy methodWithReferenceMethods:methods];
        MixLog(@"开始替换方法（请耐心等待）\n");
        [MixMainStrategy replaceMethod:copyObjects methods:referenceMethods systemMethods:frameworkMethods];
        MixLog(@"结束替换方法\n");

        MixLog(@"开始替换Protocol名称\n");
        if ([MixProtocolStrategy startWithPath:rootPath]) {
            MixLog(@"替换Protocol名称成功\n");
        } else {
            MixLog(@"替换Protocol名称出错了\n");
        }
        
        MixLog(@"开始替换Category名称\n");
        if ([[MixYAHCategoryStrategy shareInstance] start]) {
            MixLog(@"替换Category名称成功\n");
        } else {
            MixLog(@"替换Category名称出错了\n");
        }

        MixLog(@"开始替换文件名称\n");
        if ([MixFileNameStrategy start:copyObjects rootPath:rootPath mixPath:copyPath]) {
            MixLog(@"替换文件名称成功\n");
        } else {
            MixLog(@"替换文件名称出错了\n");
        }
    }
    return 0;
}
