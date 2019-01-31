//
//  MixConfig.m
//  CJMix
//
//  Created by ChenJie on 2019/1/25.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixConfig.h"
#import "../Strategy/MixObjectStrategy.h"


@interface MixConfig () {
    NSArray <NSString *>* _legalClassFrontSymbols;
    NSArray <NSString *>* _legalClassBackSymbols;
    NSArray <MixObject*>* _systemObjects;
}

@end


@implementation MixConfig

+ (instancetype)sharedSingleton {
    static MixConfig *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [MixConfig sharedSingleton];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [MixConfig sharedSingleton];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [MixConfig sharedSingleton];
}

- (void)setMixPlistPath:(NSString *)mixPlistPath {
    _mixPlistPath = mixPlistPath;
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:mixPlistPath];
    self.mixMethodPrefix = [dic objectForKey:@"Prefix"];
    self.mixMethodSuffix = [dic objectForKey:@"Suffix"];
    self.shieldClass = [dic objectForKey:@"ShieldClass"];
    self.shieldPaths = [dic objectForKey:@"ShieldPaths"];
    self.rootPath = [dic objectForKey:@"RootPath"];
    self.referencePath = [dic objectForKey:@"ReferencePath"];
    self.mixPrefix = [dic objectForKey:@"ClassPrefix"];
    self.openLog = [[dic objectForKey:@"OpenLog"] boolValue];
    self.frameworkPaths = [dic objectForKey:@"FrameworkPaths"];
}

- (NSString *)mixPrefix {
    if (!_mixPrefix) {
        _mixPrefix = @"Mix";
    }
    return _mixPrefix;
}

- (NSArray *)mixMethodPrefix {
    if (!_mixMethodPrefix) {
        _mixMethodPrefix = @[@"mix",@"cj"];
    }
    return _mixMethodPrefix;
}


- (NSArray *)mixMethodSuffix {
    if (!_mixMethodSuffix) {
        _mixMethodSuffix = @[@"Mix",@"Cj"];
    }
    return _mixMethodSuffix;
}

- (NSArray <NSString *>*)systemPrefixs {
    if (!_systemPrefixs) {
        _systemPrefixs = @[@"UI",@"NS",@"CA",@"CG"];
    }
    return _systemPrefixs;
}

- (NSArray <NSString *>*)legalClassFrontSymbols {
    if (!_legalClassFrontSymbols) {
        _legalClassFrontSymbols = @[@" ",@",",@"(",@")",@"\n",@"[",@"<"];
    }
    return _legalClassFrontSymbols;
}

- (NSArray <NSString *>*)legalClassBackSymbols {
    if (!_legalClassBackSymbols) {
        _legalClassBackSymbols = @[@" ",@"\n",@"(",@")",@"<",@"*",@";",@",",@":",@"{"];
    }
    return _legalClassBackSymbols;
}

- (NSArray <NSString *>*)shieldPaths {
    if (!_shieldPaths) {
        _shieldPaths = @[];
    }
    return _shieldPaths;
}

- (NSArray <NSString *>*)shieldClass {
    if (!_shieldClass) {
        _shieldClass = @[];
    }
    return _shieldClass;
}

- (NSArray <NSString *>*)shieldMethods {
    if (!_shieldMethods) {
        _shieldMethods = @[@"copy",@"strong",@"assign",@"retain",@"weak",@"nonatomic",@"atomic",@"NSInteger",@"instancetype",@"interface",@"implementation",@"property",@"void"];
    }
    return _shieldMethods;
}

- (NSMutableArray <NSString *>*)allProperty {
    if (!_allProperty) {
        _allProperty = [NSMutableArray arrayWithCapacity:0];
    }
    return _allProperty;
}


- (void)setSystemObjects:(NSArray<MixObject *> *)systemObjects {
    _systemObjects = systemObjects;
    [MixObjectStrategy saveObjects:systemObjects key:@"mix_system"];
}

- (NSArray<MixObject *> *)systemObjects {
    if (!_systemObjects) {
        _systemObjects = [MixObjectStrategy objectsForKey:@"mix_system"];
    }
    return _systemObjects;
}


@end
