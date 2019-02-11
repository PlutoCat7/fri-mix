//
//  FileNameStrategy.m
//  najiabao-file
//
//  Created by wangshiwen on 2019/1/24.
//  Copyright © 2019 yahua. All rights reserved.
//

#import "MixFileNameStrategy.h"
#import "MixFileNameModifyJsonInfo.h"
#import "MixFileStrategy.h"
#import "MixConfig.h"
#import "CJMix-swift.h"
#import "MixYAHCategoryStrategy.h"
#import "../category/MixYAHCategoryStrategy.h"
#import "MixDefine.h"


typedef NS_ENUM(NSUInteger, yah_MixFileType) {
    yah_MixFileType_UnKnow,
    yah_MixFileType_Group,          //文件夹
    yah_MixFileType_FileReference,  //文件
};

@interface MixPbxprojFileInfo : NSObject
@property (nonatomic, copy) NSString *UDID;
@property (nonatomic, assign) yah_MixFileType fileType;
@property (nonatomic, copy) NSString *fileName;
@end
@implementation MixPbxprojFileInfo
@end

@interface MixFileNameStrategy ()

@property (nonatomic, strong) NSArray<MixObject *> *objects;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *mixPath;

//旧类名、新类名
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *classNameDict;
@property (nonatomic, strong) NSMutableSet *fileGroupNameSet;

@property (nonatomic, strong) NSMutableArray<MixPbxprojFileInfo *> *fileList;  //文件名列表
@property (nonatomic, strong) NSMutableArray<MixPbxprojFileInfo *> *fileGroupList;  //文件夹列表

@end

@implementation MixFileNameStrategy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileList = [NSMutableArray arrayWithCapacity:1];
        _fileGroupList = [NSMutableArray arrayWithCapacity:1];
        
        _classNameDict = [NSMutableDictionary dictionaryWithCapacity:1];
        _fileGroupNameSet = [NSMutableSet setWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

+ (BOOL)start:(NSArray<MixObject *> *)objects rootPath:(NSString *)rootPath mixPath:(NSString *)mixPath{
    
    MixFileNameStrategy *strategy = [[MixFileNameStrategy alloc] init];
    strategy.objects = objects;
    strategy.rootPath = rootPath;
    strategy.mixPath = mixPath;
    
    //生成类字段
//    for (MixObject *object in objects) {
//        NSString *oldName = object.classFile.classFileName;
//        NSString *newName = object.classFile.resetFileName;
//        if (!newName && oldName && [oldName containsString:@"+"]) {//分类的情况
//            //遍历已有的类获取 修改后的文件名称
//            for (MixObject *subObject in objects) {
//                NSString *className = [oldName componentsSeparatedByString:@"+"].firstObject;
//                NSString *categoryName = [oldName componentsSeparatedByString:@"+"].lastObject;
//                if ([subObject.classFile.classFileName isEqualToString:className]) {
//                    NSString *newClassName = subObject.classFile.resetFileName;
//                    if (newClassName && newClassName.length>0) {
//                        newName = [NSString stringWithFormat:@"%@+%@", newClassName, [[MixYAHCategoryStrategy shareInstance] getNewCategoryNameWithOld:categoryName]];
//                    }
//                    break;
//                }
//            }
//        }
//        if (oldName && newName) {
//            NSDictionary *data = @{@"name":newName,
//                                   @"object":object
//                                   };
//            [strategy.classNameDict setObject:data forKey:oldName];
//        }
//    }
    
    //查找替换的类和所有分类
    [strategy findNeedModefiyFiles];
    
    //读取工程文件  提取文件名称  和文件夹
    NSString *projectJsonPath = [strategy parsePbxproj];
    if (projectJsonPath) {
        //生成配置文件
        BOOL res = [strategy makeConfigurationJson];
        //移除中间生成的文件
        [NSThread sleepForTimeInterval:2.f];
        [[NSFileManager defaultManager] removeItemAtPath:projectJsonPath error:nil];
        return res;
    }
    
    return NO;
}

#pragma mark - Private

- (void)executeConverWithPath:(NSString *)exePath{
    //plutil -convert json -s -r -o pbxproj.json project.pbxproj
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:exePath framework:NO];
    NSString *projectFolderName = nil;
    for (MixFile *itemFile in files) {
        if (itemFile.fileType == MixFileTypeProjectFolder) {
            projectFolderName = itemFile.fileName;
            break;
        }
    }
    NSTask *task = [[NSTask alloc]init];
    [task setLaunchPath: @"/bin/sh"];
    NSString *projectFilePath = [exePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/project.pbxproj",projectFolderName]];
    NSString *jsonPath = [exePath stringByAppendingPathComponent:@"pbxproj.json"];
    NSString *commandStr = [NSString stringWithFormat:@"plutil -convert json -s -r -o %@ %@",jsonPath,projectFilePath];
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",commandStr,nil];
    NSLog(@"arguments : %@",arguments);
    [task setArguments: arguments];
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    
//    NSLog (@"got\n %@", string);
    
    //确保命令执行结束文件生成
    [NSThread sleepForTimeInterval:3.f];
}

- (NSString *)parsePbxproj {
    [self executeConverWithPath:self.rootPath];
    NSString *jsonPath = [self.rootPath stringByAppendingPathComponent:@"pbxproj.json"];   //已通过plutil -convert json -s -r -o ./../pbxproj.json project.pbxproj 转成json
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (!data) {
        MixLog(@"pbxproj文件出错了");
        return nil;
    }
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *list = [result objectForKey:@"objects"];
    for (NSString *key in list) {
        NSDictionary *dict = [list objectForKey:key];
        if ([dict isKindOfClass:NSDictionary.class]) {
            NSString *isa = [dict objectForKey:@"isa"];
            if (isa && [isa isKindOfClass:NSString.class]) {
                if ([isa isEqualToString:@"PBXFileReference"]) {
                    MixPbxprojFileInfo *info = [[MixPbxprojFileInfo alloc] init];
                    info.fileType = yah_MixFileType_FileReference;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileList addObject:info];
                }else if ([isa isEqualToString:@"PBXGroup"]) {
                    MixPbxprojFileInfo *info = [[MixPbxprojFileInfo alloc] init];
                    info.fileType = yah_MixFileType_Group;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileGroupList addObject:info];
                }
            }
        }
    }
    return jsonPath;
}

- (BOOL)checkFileValidWithSuffux:(NSString *)suffix {
    
    return ([suffix isEqualToString:@"h"] || [suffix isEqualToString:@"m"]
            || [suffix isEqualToString:@"mm"]);
}

- (NSString *)keyWithUDID:(NSString *)udid {
    
    return [NSString stringWithFormat:@"objects.%@.path", udid];
}

#pragma mark - 查找需要修改的文件名称

- (void)findNeedModefiyFiles {
    
    [self recursiveFindFile:[MixConfig sharedSingleton].allFile];
}

- (void)recursiveFindFile:(NSArray *)files {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            if (![self checkIsWhiteFolder:file]) {
                [self recursiveFindFile:file.subFiles];
            }
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM) {
            //对类名进行修改
            BOOL find = NO;
            for (MixObject *object in self.objects) {
                NSString *oldFileName = [file.fileName copy];
                NSString *newFileName = [file.fileName copy];
                if (object.classFile.hFile == file ||
                    object.classFile.mFile == file) { //类名被修改了、进行类名替换
                    NSString *oldClassName = object.classFile.classFileName;
                    NSString *newClassName = object.classFile.resetFileName;
                    if (!newClassName && [oldFileName containsString:@"+"]) {//分类的情况， 但是分类没有resetFileName, 需要从正常的类中读取
                        //遍历已有的类获取 修改后的文件名称
                        for (MixObject *subObject in self.objects) {
                            NSString *className = [oldClassName componentsSeparatedByString:@"+"].firstObject;
                            NSString *categoryName = [oldClassName componentsSeparatedByString:@"+"].lastObject;
                            if ([subObject.classFile.classFileName isEqualToString:className]) {
                                NSString *newClassName = subObject.classFile.resetFileName;
                                if (newClassName && newClassName.length>0) {
                                    NSString *newCategoryName = [[MixYAHCategoryStrategy shareInstance] getNewCategoryNameWithOld:categoryName];
                                    if (!newCategoryName) {//未找到
                                        newCategoryName = categoryName;
                                    }
                                    newClassName = [NSString stringWithFormat:@"%@+%@", newClassName, newCategoryName];
                                    newFileName = [NSString stringWithFormat:@"%@.%@", newClassName, [oldFileName componentsSeparatedByString:@"."].lastObject];
                                }
                                break;
                            }
                        }
                    }else if(newClassName){
                        newFileName = [oldFileName stringByReplacingOccurrencesOfString:oldClassName withString:newClassName];
                        newFileName = [NSString stringWithFormat:@"%@.%@", newFileName, [oldFileName componentsSeparatedByString:@"."].lastObject];
                    }
                    if (oldFileName && newFileName &&
                        ![oldFileName isEqualToString:newFileName]) {
                        [self saveFile:file oldFileName:oldFileName newFileName:newFileName];
                        find = YES;
                    }
                    break;
                }
            }
            if (find) {
                continue;
            }
            //其它分类情况
            if ([file.fileName containsString:@"+"]) {//
                NSString *oldFileName = [file.fileName copy];
                NSString *string = [oldFileName componentsSeparatedByString:@"."].firstObject;
                NSString *suffx = [oldFileName componentsSeparatedByString:@"."].lastObject;
                NSString *className = [string componentsSeparatedByString:@"+"].firstObject;
                NSString *categoryName = [string componentsSeparatedByString:@"+"].lastObject;
                NSString *newCategoryName = [[MixYAHCategoryStrategy shareInstance] getNewCategoryNameWithOld:categoryName];
                if (newCategoryName && ![newCategoryName isEqualToString:categoryName]) {
                    NSString *newFileName = [NSString stringWithFormat:@"%@+%@.%@", className, newCategoryName, suffx];
                    [self saveFile:file oldFileName:oldFileName newFileName:newFileName];
                }
            }
        }
    }
}

- (void)saveFile:(MixFile *)file oldFileName:(NSString *)oldFileName newFileName:(NSString *)newFileName {
    
    //项目不规范可能会有多个文件名称相同的file
    NSDictionary *data = [self.classNameDict objectForKey:oldFileName];
    if (data) {
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:data[@"file"]];
        [tmpList addObject:file];
        NSDictionary *data = @{@"name":newFileName,
                               @"file":[tmpList copy]
                               };
        [self.classNameDict setObject:data forKey:oldFileName];
    }else {
        NSDictionary *data = @{@"name":newFileName,
                               @"file":@[file]
                               };
        [self.classNameDict setObject:data forKey:oldFileName];
    }
}

- (BOOL)checkIsWhiteFolder:(MixFile *)file {
    
    if (file.fileType != MixFileTypeFolder) {
        return YES;
    }
    return NO;
}

#pragma mark - 生成文件名称配置数据

- (BOOL)makeConfigurationJson {
    
    MixFileNameModifyJsonInfo *jsonObject = [[MixFileNameModifyJsonInfo alloc] init];
    
    //替换的文件字典  旧文件名称  新文件名称
    NSMutableDictionary *realFileNameDict = [NSMutableDictionary dictionaryWithCapacity:1];
    //对文件名称替换、及路径修改
    for (MixPbxprojFileInfo *info in self.fileList) { //也有文件名称列表
        NSString *suffix = [info.fileName componentsSeparatedByString:@"."].lastObject;
        if (![self checkFileValidWithSuffux:suffix]) {
            continue;
        }
        NSString *oldFileName = info.fileName;
        NSDictionary *dataDict = [self.classNameDict objectForKey:oldFileName];
        NSString *newFileName = [dataDict objectForKey:@"name"];
        if (newFileName && newFileName.length>0) { //找到了
            //先修改物理文件路径
            NSArray<MixFile *> *files = [dataDict objectForKey:@"file"];
            for (MixFile *file in files) {
                NSString *oldPath = file.path;
                if (oldPath && oldPath.length>0) {
                    NSString *newPath = [oldPath stringByReplacingOccurrencesOfString:oldFileName withString:newFileName];
                    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
                    if (isSuccess) {
                        NSString *key = [self keyWithUDID:info.UDID];
                        [jsonObject.backward.modify setObject:oldFileName forKey:key];
                        [jsonObject.forward.modify setObject:newFileName forKey:key];
                        
                        //eg：虽然文件名是A.h  但是#import "a.h" xcode也可以识别，所以对key做小写处理
                        [realFileNameDict setObject:newFileName forKey:[oldFileName lowercaseString]];
                        //修改数据
                        file.path = newPath;
                    }else {
                        NSString *log = [NSString stringWithFormat:@"%@.%@文件修改失败", newFileName, suffix];
                        MixLog(log);
                    }
                }
            }
        }
    }
    MixLog(@"替换#import...\n");
    [self replaceImportFile:realFileNameDict files:[MixConfig sharedSingleton].allFile];
    
    NSString *configPath = [self.rootPath stringByAppendingPathComponent:@"config.json"];
    NSError *error;
    [[jsonObject jsonString] writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSString *log = [NSString stringWithFormat:@"Pbxproj配置数据生成失败，失败原因：%@\n", error.localizedDescription];
        MixLog(log);
        return NO;
    }else{
        MixLog(@"Pbxproj配置数据生成成功\n");
        //pbxprojhelper
        id data = [PropertyListHandler parseJSONWithFileURL:[NSURL fileURLWithPath:configPath]];
        if (data) {
            NSURL *jsonFileURL = [NSURL fileURLWithPath:configPath];
            NSMutableDictionary *originalPropertyList = [NSMutableDictionary dictionary];
            id currentPropertyList = [PropertyListHandler applyWithJson:data onProjectData:originalPropertyList forward:YES];
            NSLog(@"currentPropertyList:%@",currentPropertyList);
            NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:self.mixPath framework:YES];
            NSString *projectFolderPath = nil;
            for (MixFile *itemFile in files) {
                if (itemFile.fileType == MixFileTypeProjectFolder) {
                    projectFolderPath = itemFile.path;
                    break;
                }
            }
            NSURL *propertyURL = [NSURL fileURLWithPath:projectFolderPath];
            NSURL *jsonURL = jsonFileURL;
            id propertyListData = [PropertyListHandler parseProjectWithFileURL:propertyURL];
            id jsonFileData = [PropertyListHandler parseJSONWithFileURL:jsonURL];
            originalPropertyList = propertyListData;
            currentPropertyList = [PropertyListHandler applyWithJson:jsonFileData onProjectData:originalPropertyList forward:YES];
            [PropertyListHandler generateProjectWithFileURL:propertyURL withPropertyList:currentPropertyList];
        }
        [NSThread sleepForTimeInterval:3.f];
        //移除生成的config.json文件
        [[NSFileManager defaultManager] removeItemAtPath:configPath error:nil];
        
        //修改
        return YES;
    }
    
    
    //暂时不对文件夹进行处理
    //对文件夹名称进行替换
    //    NSEnumerator * enumerator = [self.fileGroupNameSet objectEnumerator];
    //    for (MixFileInfo *info in self.fileGroupList) {
    //        NSString *newGroup = [enumerator nextObject];
    //        NSString *oldFroup = info.fileName;
    //        if ([oldFroup containsString:@"."]) {//不替换类似Assets.xcassets这种文件夹
    //            continue;
    //        }
    //        if (newGroup.length>0 && oldFroup.length>0) {
    //            [jsonObject.backward.modify setObject:oldFroup forKey:[self keyWithUDID:info.UDID]];
    //            [jsonObject.forward.modify setObject:newGroup forKey:[self keyWithUDID:info.UDID]];
    //        }
    //#warning 未完待续。。。。
    //        //修改物理文件夹名称  https://blog.csdn.net/hsf_study/article/details/46993099
    //    }
    
}

#pragma mark - 替换import

- (BOOL)replaceImportFile:(NSDictionary *)fileNameDict files:(NSArray<MixFile *> *)files{
    
    for (MixFile *file in files) {
        //
        @autoreleasepool {
            if (file.subFiles.count>0) {
                [self replaceImportFile:fileNameDict files:file.subFiles];
            }else {
                if (file.fileType == MixFileTypeH ||
                    file.fileType == MixFileTypeM ||
                    file.fileType == MixFileTypeMM ||
                    file.fileType == MixFileTypePch) {
                    [self handleMixFile:file fileNameDict:fileNameDict];
                }
            }
        }
    }

    return YES;
}

- (void)handleMixFile:(MixFile *)file fileNameDict:(NSDictionary *)fileNameDict {
    
    NSString *string = file.data;
    if (!string || string.length == 0) {
        return;
    }
    NSArray *lineList = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:lineList];
    for (NSInteger index =0; index<lineList.count; index++) {
        NSString *lineString = lineList[index];
        if (![lineString containsString:@"#import"]) {
            continue;
        }
        NSRange curRange = [lineString rangeOfString:@"(?<=\").*(?=\")" options:NSRegularExpressionSearch];
        if (curRange.location == NSNotFound)
            continue;
        NSString *curStr = [lineString substringWithRange:curRange];
        if ([curStr containsString:@"/"]) { //引文文件可能是这个格式 ./a.h
            curStr = [curStr componentsSeparatedByString:@"/"].lastObject;
        }
        //对文件名做小写处理， eg：虽然文件名是A.h  但是#import "a.h" xcode也可以识别，坑啊。。。 
        NSString *newName = [fileNameDict objectForKey:[curStr lowercaseString]];
        if (newName) {
            NSString *tmpString = [lineString stringByReplacingOccurrencesOfString:curStr withString:newName];
            [tmpList replaceObjectAtIndex:index withObject:tmpString];
        }
    }
    
    string = [tmpList componentsJoinedByString:@"\n"];
    if (![string isEqualToString:file.data]) {
        file.data = string;
        [MixFileStrategy writeFileAtPath:file.path content:file.data];
    }
}

@end
