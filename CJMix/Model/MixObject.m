//
//  MixObject.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixObject.h"
#import "MixStringStrategy.h"
#import "../Strategy/MixFilterStrategy.h"

@implementation MixObject

- (instancetype)initWithClassFile:(MixClassFile *)file {
    self = [super init];
    if (self) {
        _classFile = file;
        [self analyze];
    }
    return self;
    
}

- (void)analyze {
    
    if (self.classFile.hFile) {
        NSData * hData = [NSData dataWithContentsOfFile:self.classFile.hFile.path options:NSDataReadingUncached error:nil];
        NSString * hText  = [[NSString alloc] initWithData:hData encoding:NSUTF8StringEncoding];
        self.classFile.hFile.data = hText;
        
        _hClasses = [NSArray arrayWithArray:[self dataToClassName:hText]];
    }
    
    if (self.classFile.mFile) {
        
        NSData * mData = [NSData dataWithContentsOfFile:self.classFile.mFile.path options:NSDataReadingUncached error:nil];
        NSString * mText = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
        self.classFile.mFile.data = mText;
        _mClasses = [NSArray arrayWithArray:[self dataToClassName:mText]];
    }
    
}


- (NSArray <MixClass *>*)dataToClassName:(NSString *)data {
    __block NSMutableArray <MixClass *>* classNames = [NSMutableArray arrayWithCapacity:0];

    NSArray <NSString *>* classes = [data componentsSeparatedByString:@"@interface"];
    if (classes.count > 1) {
        [classes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0 && [obj containsString:@":"]) {
                
                NSArray <NSString *>* blanks = [obj componentsSeparatedByString:@" "];
                NSString * classStr = nil;
                for (int ii = 0; ii < blanks.count; ii++) {
                    NSString * str = blanks[ii];
                    if (!str.length) {
                        continue;
                    }
                    
                    if ([str containsString:@":"]) {
                        NSArray <NSString *>* strs = [obj componentsSeparatedByString:@":"];
                        
                        if (strs.count) {
                            NSString * temp = strs[0];
                            NSString * replacing = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
                            classStr = replacing;
                            break;
                        }
                        
                    } else {
                        if ([MixStringStrategy isAlphaNum:str]) {
                            classStr = str;
                            break;
                        }
                    }
                    
                }
                
                if (classStr && ![MixFilterStrategy isSystemClass:classStr]) {
                    MixClass * class = [[MixClass alloc] initWithClassName:classStr];
                    [class methodFromData:data];
                    [classNames addObject:class];
                }
            }
        }];
    }
    
    return classNames;
}



@end
