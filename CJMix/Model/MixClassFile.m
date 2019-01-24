//
//  MixClassFile.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixClassFile.h"
#import "MixFile.h"

@implementation MixClassFile

- (void)setHFile:(MixFile *)hFile {
    _hFile = hFile;
    [self classFileName];
}

- (void)setMFile:(MixFile *)mFile {
    _mFile = mFile;
    [self classFileName];
}

- (NSString *)classFileName {
    if ([self.hFile isKindOfClass:[MixFile class]] || [self.mFile isKindOfClass:[MixFile class]]) {
        if (self.hFile) {
            _classFileName = [self.hFile.fileName stringByReplacingOccurrencesOfString:@".h" withString:@""];
        } else {
            _classFileName = [self.mFile.fileName stringByReplacingOccurrencesOfString:@".m" withString:@""];
        }
        
        if ([_classFileName containsString:@"AppDelegate"]) {
            _isAppDelegate = YES;
        }
        
        if ([_classFileName containsString:@"+"]) {
            _isCategory = YES;
        }
        
    }
    return _classFileName;
}

@end
