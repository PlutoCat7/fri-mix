//
//  FileNameStrategy.m
//  najiabao-file
//
//  Created by wangshiwen on 2019/1/24.
//  Copyright © 2019 yahua. All rights reserved.
//

#import "MixFileNameStrategy.h"
#import "MixFileNameModifyJsonInfo.h"

typedef NS_ENUM(NSUInteger, MixFileType) {
    MixFileType_UnKnow,
    MixFileType_Group,          //文件夹
    MixFileType_FileReference,  //文件
};

@interface MixFileInfo : NSObject
@property (nonatomic, copy) NSString *UDID;
@property (nonatomic, assign) MixFileType fileType;
@property (nonatomic, copy) NSString *fileName;
@end
@implementation MixFileInfo
@end

@interface MixFileNameStrategy ()

//旧类名、新类名
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *classNameDict;

@property (nonatomic, strong) NSMutableArray<MixFileInfo *> *fileList;
@property (nonatomic, strong) NSMutableArray<MixFileInfo *> *fileGroupList;

@end

@implementation MixFileNameStrategy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileList = [NSMutableArray arrayWithCapacity:1];
        _fileGroupList = [NSMutableArray arrayWithCapacity:1];
        
        _classNameDict = @{@"file-7":@"file-8"};
        
        if ([self initPbxproj]) {
            [self makeConfigurationJson];
        }
    }
    return self;
}

#pragma mark - Public

- (void)test {
    
    
}

#pragma mark - Private

- (BOOL)initPbxproj {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pbxproj" ofType:@"json"];  //已通过plutil -convert json -s -r -o my.json project.pbxproj 转成json
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
                    info.fileType = MixFileType_FileReference;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileList addObject:info];
                }else if ([isa isEqualToString:@"PBXGroup"]) {
                    MixFileInfo *info = [[MixFileInfo alloc] init];
                    info.fileType = MixFileType_Group;
                    info.UDID = key;
                    info.fileName = [dict objectForKey:@"path"];
                    [self.fileGroupList addObject:info];
                }
            }
        }
    }
    return YES;
}

- (void)makeConfigurationJson {
    
    MixFileNameModifyJsonInfo *jsonObject = [[MixFileNameModifyJsonInfo alloc] init];
    for (MixFileInfo *info in self.fileList) {
        NSString *suffix = [info.fileName componentsSeparatedByString:@"."].lastObject;
        if (![self checkFileValidWithSuffux:suffix]) {
            continue;
        }
        //去除后缀 当做类名比对
        NSString *fileName = [info.fileName componentsSeparatedByString:@"."].firstObject;
        NSString *newFileName = [self.classNameDict objectForKey:fileName];
        if (newFileName && newFileName.length>0) { //找到了
            NSString *key = [self keyWithUDID:info.UDID];
            [jsonObject.backward.modify setObject:info.fileName forKey:key];
            [jsonObject.forward.modify setObject:[NSString stringWithFormat:@"%@.%@", newFileName, suffix] forKey:key];
        }
    }
    NSLog(@"Pbxproj配置修改数据：%@", [jsonObject jsonString]);
}

- (BOOL)checkFileValidWithSuffux:(NSString *)suffix {
    
    return ([suffix isEqualToString:@"h"] || [suffix isEqualToString:@"m"]);
}

- (NSString *)keyWithUDID:(NSString *)udid {
    
    return [NSString stringWithFormat:@"objects.%@.path", udid];
}

@end
