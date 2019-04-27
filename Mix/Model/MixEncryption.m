//
//  MixEncryption.m
//  CJMix
//
//  Created by ChenJie on 2019/2/2.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixEncryption.h"
#import "../Strategy/MixStringStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixEncryption

+ (instancetype)encryptionWithFile:(MixFile *)file {
    
    __block MixEncryption * encryption = nil;
    
    if (!file.data || !file.path) {
        return nil;
    }
    
    if (![[MixConfig sharedSingleton].encryptionDictionary.allKeys containsObject:file.path]) {
        [MixStringStrategy encryption:file.data originals:nil block:^(NSArray<NSString *> *originals, NSArray<NSString *> *replaces, NSString *encryptionData) {
            MixEncryption * encrypt = [[MixEncryption alloc] init];
            encrypt.encryptionData = encryptionData;
            encrypt.originals = originals;
            encrypt.replaces = replaces;
            [MixConfig sharedSingleton].encryptionDictionary[file.path] = encrypt;
            encryption = encrypt;
        }];
    } else {
        encryption = [MixConfig sharedSingleton].encryptionDictionary[file.path];
    }
    
    return encryption;
}

@end
