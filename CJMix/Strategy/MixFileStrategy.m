//
//  MixFileStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixFileStrategy.h"

@implementation MixFileStrategy

+ (NSArray <MixFile *>*)filesWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray <NSString *>* paths = [fm contentsOfDirectoryAtPath:path error:NULL];
    __block NSMutableArray <MixFile *> *files = [NSMutableArray arrayWithCapacity:0];
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MixFile * file = [MixFileStrategy fileWithPath:[NSString stringWithFormat:@"%@/%@",path,obj]];
        if (file) {
            [files addObject:file];
        }
    }];
    return files;
}

+ (MixFile *)projectWithFilesWithPath:(NSString *)path {
    __block MixFile * file = nil;
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:path];
    [files enumerateObjectsUsingBlock:^(MixFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.fileType == MixFileTypeProject) {
            file = obj;
        }
    }];
    return file;
}

+ (MixFile *)fileWithPath:(NSString *)path {
    MixFile * file = [[MixFile alloc] init];

    if ([MixFileStrategy isDirectoryAtPath:path error:nil]) {
        if ([path hasSuffix:@".pbxproj"]) {
            file.fileType = MixFileTypeProject;
        } else if ([path hasSuffix:@"Pods"]||[path hasSuffix:@"imkit"]||[path hasSuffix:@"imsdk"]||[path hasSuffix:@"FDFullscreenPopGesture"]||[path hasSuffix:@"UIAlertView+BlocksKit"]||[path hasSuffix:@"V8HorizontalPickerView"]||[path hasSuffix:@"MJExtension"]||[path hasSuffix:@"FBKVOController"]||[path hasSuffix:@"countly-sdk-ios"]||[path hasSuffix:@"Hockey-iOS"]) {
            file.fileType = MixFileTypePodFolder;
        } else if ([path hasSuffix:@".framework"]) {
            file.fileType = MixFileTypeFramework;
        } else {
            file.fileType = MixFileTypeFolder;
        }
        file.subFiles = [MixFileStrategy filesWithPath:path];
    } else {
        if ([path hasSuffix:@".h"]) {
            file.fileType = MixFileTypeH;
        } else if ([path hasSuffix:@".mm"]) {
            file.fileType = MixFileTypeMM;
        } else if ([path hasSuffix:@".m"]) {
            file.fileType = MixFileTypeM;
        }
    }
    
    if (file.fileType == MixFileTypeUnknown) {
        return nil;
    }
    
    if (file.fileType == MixFileTypePodFolder) {
        return nil;
    }
    
    if (file.fileType == MixFileTypeFramework) {
        return nil;
    }
    
    file.path = path;
    file.fileName = [path lastPathComponent];
    return file;
}

+ (NSArray <MixFile *>*)filesToHMFiles:(NSArray <MixFile *>*) files {
    NSArray <MixFile *> * hmFiles = [NSArray arrayWithArray:[MixFileStrategy hmFilesWithFiles:files saveHMFiles:nil]];
    return hmFiles;
}

+ (NSMutableArray <MixFile *>*)hmFilesWithFiles:(NSArray <MixFile *>*)rootFiles saveHMFiles:(NSMutableArray <MixFile *>*)hmFiles {
    NSMutableArray <MixFile *>* saveHMFiles = nil;
    if (hmFiles) {
        saveHMFiles = hmFiles;
    } else {
        saveHMFiles = [NSMutableArray arrayWithCapacity:0];
    }
    
    [rootFiles enumerateObjectsUsingBlock:^(MixFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.subFiles.count) {
            [self hmFilesWithFiles:obj.subFiles saveHMFiles:saveHMFiles];
        } else if (obj.fileType == MixFileTypeH || obj.fileType == MixFileTypeM || obj.fileType == MixFileTypeMM) {
            [saveHMFiles addObject:obj];
        }
    }];
    
    return saveHMFiles;
}




/**
 获取文件特定属性
 @param path 目录
 @param key 属性键值
 @param error 错误信息
 @return 文件信息
 */
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    NSDictionary * dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
    id object = [dic objectForKey:key];
    return object;
}

/**
 是否为文件夹
 @param path 目录
 @param error 错误信息
 @return 是否
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
}


+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    
    if (![self isExistsAtPath:path]) {
        return NO;
    }
    NSFileManager *manager = [NSFileManager defaultManager];

    NSString *toDirPath = [path stringByDeletingLastPathComponent];
    if (![self isExistsAtPath:toDirPath]) {
        BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
        if (!isSuccess) {
            return NO;
        }
    }
    
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [manager removeItemAtPath:toPath error:error];
        }
    }
    BOOL isSuccess = [manager copyItemAtPath:path toPath:toPath error:error];
    return isSuccess;
}

+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSString *)content {
    if ([self isExistsAtPath:path]) {
        BOOL isSucceed = [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
         return isSucceed;
    }
    return NO;
}


@end
