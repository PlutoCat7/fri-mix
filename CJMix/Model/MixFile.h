//
//  MixFile.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixEncryption.h"


typedef NS_ENUM(NSUInteger, MixFileType) {
    MixFileTypeUnknown,
    MixFileTypeFolder,
    MixFileTypeH,
    MixFileTypeM,
    MixFileTypeMM,
    MixFileTypePch,
    MixFileTypeProject,
    MixFileTypeProjectFolder,
    MixFileTypePodFolder,
    MixFileTypeFramework,
    MixFileTypeShield
};


@interface MixFile : NSObject <NSCoding>

@property (nonatomic , assign) MixFileType fileType;

@property (nonatomic , copy) NSString * path;

@property (nonatomic , copy) NSString * fileName;

@property (nonatomic , copy) NSString * data;

@property (nonatomic , copy) NSArray <MixFile *>* subFiles;

@end

