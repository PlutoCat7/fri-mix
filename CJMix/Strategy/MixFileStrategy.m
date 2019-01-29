//
//  MixFileStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixFileStrategy.h"
#import "MixJudgeStrategy.h"

@implementation MixFileStrategy

+ (NSArray <MixFile *>*)filesWithPath:(NSString *)path framework:(BOOL)framework {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray <NSString *>* paths = [fm contentsOfDirectoryAtPath:path error:NULL];
    __block NSMutableArray <MixFile *> *files = [NSMutableArray arrayWithCapacity:0];
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MixFile * file = [MixFileStrategy fileWithPath:[NSString stringWithFormat:@"%@/%@",path,obj] framework:framework];
        if (file) {
            [files addObject:file];
        }
    }];
    return files;
}

+ (NSArray <MixFile *>*)filesToPCHFiles:(NSArray <MixFile *>*)files {
    __block NSMutableArray <MixFile *> *pchFiles = [MixFileStrategy pchFilesWithFiles:files savePCHFiles:nil];
    return pchFiles;
}

+ (NSMutableArray <MixFile *>*)pchFilesWithFiles:(NSArray <MixFile *>*)rootFiles savePCHFiles:(NSMutableArray <MixFile *>*)savePCHFiles {
    NSMutableArray <MixFile *>* PCHFiles = nil;
    if (savePCHFiles) {
        PCHFiles = savePCHFiles;
    } else {
        PCHFiles = [NSMutableArray arrayWithCapacity:0];
    }
    
    [rootFiles enumerateObjectsUsingBlock:^(MixFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.subFiles.count) {
            [self pchFilesWithFiles:obj.subFiles savePCHFiles:PCHFiles];
        } else if (obj.fileType == MixFileTypePch) {
            [PCHFiles addObject:obj];
        }
    }];
    
    return PCHFiles;
}

+ (MixFile *)fileWithPath:(NSString *)path framework:(BOOL)framework {
    MixFile * file = [[MixFile alloc] init];

    if ([MixFileStrategy isDirectoryAtPath:path error:nil]) {
        if ([path hasSuffix:@".pbxproj"]) {
            file.fileType = MixFileTypeProject;
        } else if ([path hasSuffix:@"Pods"]) {
            file.fileType = MixFileTypePodFolder;
        } else if ([path hasSuffix:@".framework"]) {
            file.fileType = MixFileTypeFramework;
        } else if ([MixJudgeStrategy isShieldWithPath:path]) {
            file.fileType = MixFileTypeShield;
        } else {
            file.fileType = MixFileTypeFolder;
        }
        file.subFiles = [MixFileStrategy filesWithPath:path framework:framework];
    } else {
        if ([path hasSuffix:@".h"]) {
            file.fileType = MixFileTypeH;
        } else if ([path hasSuffix:@".mm"]) {
            file.fileType = MixFileTypeMM;
        } else if ([path hasSuffix:@".m"]) {
            file.fileType = MixFileTypeM;
        } else if ([path hasSuffix:@".pch"]) {
            file.fileType = MixFileTypePch;
        }
    }
    
    if (file.fileType == MixFileTypeUnknown) {
        return nil;
    }
    
    if ((file.fileType == MixFileTypeFramework|| file.fileType == MixFileTypePodFolder ) && !framework) {
        return nil;
    }
    
    file.path = path;
    file.fileName = [path lastPathComponent];
    return file;
}

+ (NSArray <MixFile *>*)filesToHMFiles:(NSArray <MixFile *>*)files {
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
        if (obj.subFiles.count && obj.fileType!=MixFileTypeShield) {
            [self hmFilesWithFiles:obj.subFiles saveHMFiles:saveHMFiles];
        } else if (obj.fileType == MixFileTypeH || obj.fileType == MixFileTypeM || obj.fileType == MixFileTypeMM) {
            [saveHMFiles addObject:obj];
        }
    }];
    
    return saveHMFiles;
}

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    NSDictionary * dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
    id object = [dic objectForKey:key];
    return object;
}


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
