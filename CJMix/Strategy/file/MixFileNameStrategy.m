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
    
    if ([strategy initPbxproj]) {
        [strategy makeConfigurationJson];
    }
    return NO;
}

#pragma mark - Private

- (void)executeConverWithPath:(NSString *)exePath{
    //plutil -convert json -s -r -o pbxproj.json project.pbxproj
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:exePath];
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
    
    NSLog (@"got\n %@", string);
    
    //确保命令执行结束文件生成
    [NSThread sleepForTimeInterval:3.f];
}

- (BOOL)initPbxproj {
    [self executeConverWithPath:self.rootPath];
    NSString *jsonPath = [self.rootPath stringByAppendingPathComponent:@"pbxproj.json"];   //已通过plutil -convert json -s -r -o ./../pbxproj.json project.pbxproj 转成json
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (!data) {
        NSLog(@"pbxproj文件出错了");
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

- (BOOL)makeConfigurationJson {
    
    MixFileNameModifyJsonInfo *jsonObject = [[MixFileNameModifyJsonInfo alloc] init];
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
            }
        }
    }
    
    NSLog(@"Pbxproj配置修改数据：%@", [jsonObject jsonString]);
    
    NSString *configPath = [self.rootPath stringByAppendingPathComponent:@"config.json"];
    NSError *error;
    [[jsonObject jsonString] writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Pbxproj配置数据写入失败，失败原因：%@", error);
        return NO;
    }else{
        NSLog(@"Pbxproj配置数据写入成功");
        return YES;
    }
}

- (BOOL)checkFileValidWithSuffux:(NSString *)suffix {
    
    return ([suffix isEqualToString:@"h"] || [suffix isEqualToString:@"m"]
            || [suffix isEqualToString:@"mm"]);
}

- (NSString *)keyWithUDID:(NSString *)udid {
    
    return [NSString stringWithFormat:@"objects.%@.path", udid];
}

@end
