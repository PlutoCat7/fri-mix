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

typedef NS_ENUM(NSUInteger, yah_MixFileType) {
    yah_MixFileType_UnKnow,
    yah_MixFileType_Group,          //文件夹
    yah_MixFileType_FileReference,  //文件
};

@interface MixFileInfo : NSObject
@property (nonatomic, copy) NSString *UDID;
@property (nonatomic, assign) yah_MixFileType fileType;
@property (nonatomic, copy) NSString *fileName;
@end
@implementation MixFileInfo
@end

@interface MixFileNameStrategy ()

@property (nonatomic, strong) NSArray<MixObject *> *objects;
@property (nonatomic, copy) NSString *rootPath;

//旧类名、新类名
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *classNameDict;
@property (nonatomic, strong) NSMutableSet *fileGroupNameSet;

@property (nonatomic, strong) NSMutableArray<MixFileInfo *> *fileList;  //文件名列表
@property (nonatomic, strong) NSMutableArray<MixFileInfo *> *fileGroupList;  //文件夹列表

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

+ (BOOL)start:(NSArray<MixObject *> *)objects rootPath:(NSString *)rootPath {
    
    MixFileNameStrategy *strategy = [[MixFileNameStrategy alloc] init];
    strategy.objects = objects;
    strategy.rootPath = rootPath;
    
    //生成类字段
    for (MixObject *object in objects) {
        NSString *oldName = object.classFile.classFileName;
        NSString *newName = object.classFile.resetFileName;
        if (oldName && newName) {
            NSDictionary *data = @{@"name":newName,
                                   @"object":object
                                   };
            [strategy.classNameDict setObject:data forKey:oldName];
        }
    }
    
    //读取工程文件  提取文件名称  和文件夹
    if ([strategy initPbxproj]) {
        //生成配置文件
        return [strategy makeConfigurationJson];
    }
    return NO;
}

#pragma mark - Private

- (BOOL)initPbxproj {
    
    NSString *jsonPath = [self.rootPath stringByAppendingPathComponent:@"pbxproj.json"];   //已通过plutil -convert json -s -r -o my.json project.pbxproj 转成json
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (!data) {
        printf("pbxproj文件出错了");
        return NO;
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
                    MixFileInfo *info = [[MixFileInfo alloc] init];
                    info.fileType = yah_MixFileType_FileReference;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileList addObject:info];
                }else if ([isa isEqualToString:@"PBXGroup"]) {
                    MixFileInfo *info = [[MixFileInfo alloc] init];
                    info.fileType = yah_MixFileType_Group;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileGroupList addObject:info];
                }
            }
        }
    }
    return YES;
}

//读取文件夹数据 生成数组
- (void)readFileGroupData {
    
    NSString *jsonPath = [self.rootPath stringByAppendingPathComponent:@"fileGroup.json"];   //已通过plutil -convert json -s -r -o my.json project.pbxproj 转成json
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (!data) {
        return;
    }
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *list = [result objectForKey:@"objects"];
    for (NSString *key in list) {
        NSDictionary *dict = [list objectForKey:key];
        if ([dict isKindOfClass:NSDictionary.class]) {
            NSString *isa = [dict objectForKey:@"isa"];
            if (isa && [isa isKindOfClass:NSString.class]) {
                if ([isa isEqualToString:@"PBXGroup"]) {
                    NSString *fileGroupName = [dict objectForKey:@"path"];
                    if (fileGroupName.length>0) {
                        [self.fileGroupNameSet addObject:fileGroupName];
                    }
                }
            }
        }
    }
}

- (BOOL)checkFileValidWithSuffux:(NSString *)suffix {
    
    return ([suffix isEqualToString:@"h"] || [suffix isEqualToString:@"m"]
            || [suffix isEqualToString:@"mm"]);
}

- (NSString *)keyWithUDID:(NSString *)udid {
    
    return [NSString stringWithFormat:@"objects.%@.path", udid];
}

#pragma mark - 生成文件名称配置数据

- (BOOL)makeConfigurationJson {
    
    MixFileNameModifyJsonInfo *jsonObject = [[MixFileNameModifyJsonInfo alloc] init];
    
    //替换的文件字典  旧文件名称  新文件名称
    NSMutableDictionary *realFileNameDict = [NSMutableDictionary dictionaryWithCapacity:1];
    //对文件名称替换
    for (MixFileInfo *info in self.fileList) {
        NSString *suffix = [info.fileName componentsSeparatedByString:@"."].lastObject;
        if (![self checkFileValidWithSuffux:suffix]) {
            continue;
        }
        //去除后缀 当做类名比对
        NSString *oldFileName = [info.fileName componentsSeparatedByString:@"."].firstObject;
        NSDictionary *dataDict = [self.classNameDict objectForKey:oldFileName];
        NSString *newFileName = [dataDict objectForKey:@"name"];
        if (newFileName && newFileName.length>0) { //找到了
            NSString *key = [self keyWithUDID:info.UDID];
            [jsonObject.backward.modify setObject:info.fileName forKey:key];
            [jsonObject.forward.modify setObject:[NSString stringWithFormat:@"%@.%@", newFileName, suffix] forKey:key];
            
            [realFileNameDict setObject:[NSString stringWithFormat:@"%@.%@", newFileName, suffix] forKey:info.fileName];
            
            //修改物理文件路径
            MixObject *object = [dataDict objectForKey:@"object"];
            NSString *oldPath = nil;
            if ([suffix isEqualToString:@"h"]) {
                oldPath = object.classFile.hFile.path;
            }else {
                oldPath = object.classFile.mFile.path;
            }
            if (oldPath && oldPath.length>0) {
                
                NSString *newPath = [[NSMutableString stringWithString:oldPath] stringByReplacingOccurrencesOfString:oldFileName withString:newFileName];
                [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
                //修改数据
                if ([suffix isEqualToString:@"h"]) {
                    object.classFile.hFile.path = newPath;
                }else {
                    object.classFile.mFile.path = newPath;
                }
            }
        }
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
    
    NSString *configPath = [self.rootPath stringByAppendingPathComponent:@"config.json"];
    NSError *error;
    [[jsonObject jsonString] writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        printf("Pbxproj配置数据生成失败，失败原因：%s\n", [error.localizedDescription UTF8String]);
        return NO;
    }else{
        printf("Pbxproj配置数据生成成功\n");
        //修改
        return [self replaceImportFile:realFileNameDict];
    }
}

#pragma mark - 替换import

- (BOOL)replaceImportFile:(NSDictionary *)fileNameDict {
    
    printf("开始替换import文件\n");
    for (MixObject *object in self.objects) {
        //
        MixFile *hFile = object.classFile.hFile;
        MixFile *mFile = object.classFile.mFile;
        
        NSMutableString *h_mutableString = [NSMutableString stringWithString:hFile.data];
        NSMutableString *m_mutableString = [NSMutableString stringWithString:mFile.data];
        for (NSString *key in fileNameDict) {
            NSString *oldName = key;  
            NSString *newName = fileNameDict[key];
            [h_mutableString replaceOccurrencesOfString:oldName withString:newName options:NSCaseInsensitiveSearch range:NSMakeRange(0, h_mutableString.length)];
            [m_mutableString replaceOccurrencesOfString:oldName withString:newName options:NSCaseInsensitiveSearch range:NSMakeRange(0, m_mutableString.length)];
        }
        if (![h_mutableString isEqualToString:hFile.data]) {
            hFile.data = h_mutableString;
            [MixFileStrategy writeFileAtPath:hFile.path content:hFile.data];
        }
        if (![m_mutableString isEqualToString:mFile.data]) {
            mFile.data = m_mutableString;
            [MixFileStrategy writeFileAtPath:mFile.path content:mFile.data];
        }
    }
    printf("结束替换import文件\n");
    return YES;
}

@end
