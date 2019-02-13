//
//  MixConfig.h
//  CJMix
//
//  Created by ChenJie on 2019/1/25.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixFile.h"
#import "../Model/MixObject.h"

@interface MixConfig : NSObject

+ (instancetype)sharedSingleton;

@property (nonatomic , assign) BOOL openLog;

@property (nonatomic , assign) BOOL absolutePath;

@property (nonatomic , copy) NSString * mixPrefix;

@property (nonatomic , copy) NSArray * mixMethodPrefix;

@property (nonatomic , copy) NSArray * mixMethodSuffix;

@property (nonatomic , copy) NSString * argvFolderPath;

@property (nonatomic , copy) NSString * mixPlistPath;

@property (nonatomic , copy) NSString * rootPath;

@property (nonatomic , copy) NSString * referencePath;

@property (nonatomic , copy) NSArray <NSString *>* systemPrefixs;

@property (nonatomic , copy) NSArray <NSString *>* frameworkPaths;

@property (nonatomic , copy) NSArray <NSString *>* shieldPaths;

@property (nonatomic , copy) NSArray <NSString *>* shieldSystemParameter;

@property (nonatomic , copy) NSArray <NSString *>* shieldClass;

@property (nonatomic , copy) NSArray <NSString *>* shieldSystemMethodNames;

@property (nonatomic , copy) NSArray <MixFile *>* pchFile;

@property (nonatomic , copy) NSArray <MixFile *>* allFile;  //所有文件
@property (nonatomic , copy) NSArray <MixFile *>* referenceAllFile;  //参考工程的所有文件

@property (nonatomic , copy) NSArray <NSString *>* shieldPropertyClass;

@property (nonatomic , copy) NSMutableArray <NSString *>* shieldProperty;

@property (nonatomic , copy) NSMutableDictionary * mixClassCache;

@property (nonatomic , copy) NSMutableDictionary * mixMethodCache;

@property (nonatomic , copy , readonly) NSArray <NSString *>* legalClassFrontSymbols;

@property (nonatomic , copy , readonly) NSArray <NSString *>* legalClassBackSymbols;

@property (nonatomic , copy) NSArray <MixObject*>* systemObjects;

@property (nonatomic , copy) NSMutableDictionary * encryptionDictionary;

- (void)saveCache;

@end

