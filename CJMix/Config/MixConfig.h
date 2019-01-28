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

@property (nonatomic , copy) NSString * mixPrefix;

@property (nonatomic , copy) NSString * mixMethodPrefix;

@property (nonatomic , copy) NSArray <NSString *>* systemPrefixs;

@property (nonatomic , copy) NSArray <NSString *>* shieldPaths;

@property (nonatomic , copy) NSArray <NSString *>* shieldMethods;

@property (nonatomic , copy) NSArray <MixFile *>* pchFile;

@property (nonatomic , copy) NSArray <MixFile *>* allFile;  //所有文件

@property (nonatomic , copy , readonly) NSArray <NSString *>* legalClassFrontSymbols;

@property (nonatomic , copy , readonly) NSArray <NSString *>* legalClassBackSymbols;

@property (nonatomic , copy) NSArray <MixObject*>* systemObjects;

@end

