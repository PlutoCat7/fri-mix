//
//  MixEncryption.h
//  CJMix
//
//  Created by ChenJie on 2019/2/2.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixFile.h"

@interface MixEncryption : NSObject

@property (nonatomic , copy) NSString * encryptionData;

@property (nonatomic , copy) NSArray<NSString *> *originals;

@property (nonatomic , copy) NSArray<NSString *> *replaces;

+ (instancetype)encryptionWithFile:(MixFile *)file;

@end
