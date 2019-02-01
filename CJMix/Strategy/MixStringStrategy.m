//
//  MixStringStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixStringStrategy.h"

@implementation MixStringStrategy

+ (BOOL)isAlphaNum:(NSString *)string {
    NSString *regex =@"[a-zA-Z0-9_]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
    
}

+ (BOOL)isProperty:(NSString *)string {
    NSString *regex =@"[a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
    
}

+ (NSString *)capitalizeTheFirstLetter:(NSString *)string {
    if (!string.length) {
        return string;
    }
    NSString * stringCopy = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] uppercaseString]];
    return stringCopy;
}

+ (NSString *)filterOutImpurities:(NSString *)string {
    NSString * newData = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    newData = [newData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newData = [newData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return newData;
}


+ (void)encryption:(NSString *)data originals:(NSMutableArray *)originals block:(MixEncryptionBlock)block {
    @autoreleasepool {
        if (!originals) {
            originals = [NSMutableArray arrayWithCapacity:0];
        }
        
        NSString * copyData = [NSString stringWithFormat:@"%@",data];
        
        NSRange curRange = [copyData rangeOfString:@"(?<=\")([\\S]+?)(?=\")" options:NSRegularExpressionSearch];
        if (curRange.location != NSNotFound) {
            NSString * front = [copyData substringToIndex:curRange.location - 1];
            NSString * back = [copyData substringFromIndex:curRange.location + curRange.length+1];
            NSString * placeholder = [MixStringStrategy placeholder:originals.count];
            NSString * string = [copyData substringWithRange:NSMakeRange(curRange.location - 1, curRange.length + 2)];
            [originals addObject:string];
            NSString * encryptionData = [NSString stringWithFormat:@"%@%@%@",front,placeholder,back];
            [MixStringStrategy encryption:encryptionData originals:originals block:block];
            
        } else {
            NSMutableArray * replaces = [NSMutableArray arrayWithCapacity:0];
            for (int ii = 0; ii < originals.count; ii++) {
                NSString * replace = [MixStringStrategy placeholder:ii];
                [replaces addObject:replace];
            }
            
            if (block) {
                block(originals,replaces,copyData);
            }
        }
    }
}

+ (NSString *)decoding:(NSString*)data originals:(NSArray <NSString*>*)originals replaces:(NSArray <NSString*>*)replaces {
    @autoreleasepool {
        NSString * decoding = [NSString stringWithFormat:@"%@",data];
        for (int ii = 0; ii < originals.count; ii++) {
            NSString * original = originals[ii];
            NSString * replace = replaces[ii];
            decoding = [decoding stringByReplacingOccurrencesOfString:replace withString:original];
        }
    return decoding;
    }
}

+ (NSString *)placeholder:(NSInteger)index {
    return [NSString stringWithFormat:@"^^^^^^&&&&&&######%@******",@(index)];
}


@end
