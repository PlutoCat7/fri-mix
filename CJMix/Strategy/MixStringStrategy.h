//
//  MixStringStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MixEncryptionBlock)(NSArray <NSString*>* originals ,NSArray <NSString*>* replaces , NSString * encryptionData);

@interface MixStringStrategy : NSObject

+ (BOOL)isAlphaNumUnderline:(NSString *)string;

+ (BOOL)isAlphaNum:(NSString *)string;

+ (NSString *)filterOutImpurities:(NSString *)string;

+ (void)encryption:(NSString *)data originals:(NSMutableArray *)originals block:(MixEncryptionBlock)block;

+ (NSString *)decoding:(NSString*)data originals:(NSArray <NSString*>*)originals replaces:(NSArray <NSString*>*)replaces;

+ (NSString *)capitalizeTheFirstLetter:(NSString *)string;

@end
