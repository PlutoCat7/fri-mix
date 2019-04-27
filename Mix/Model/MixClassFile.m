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

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _hFile = [aDecoder decodeObjectForKey:@"hFile"];
        _mFile = [aDecoder decodeObjectForKey:@"hmFile"];
        _classFileName = [aDecoder decodeObjectForKey:@"classFileName"];
        _resetFileName = [aDecoder decodeObjectForKey:@"resetFileName"];
        _isAppDelegate = [aDecoder decodeBoolForKey:@"isAppDelegate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_hFile forKey:@"hFile"];
    [aCoder encodeObject:_mFile forKey:@"hmFile"];
    [aCoder encodeObject:_classFileName forKey:@"classFileName"];
    [aCoder encodeObject:_resetFileName forKey:@"resetFileName"];
    [aCoder encodeBool:_isAppDelegate forKey:@"isAppDelegate"];
}


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
            if (_mFile.fileType == MixFileTypeM) {
                _classFileName = [self.mFile.fileName stringByReplacingOccurrencesOfString:@".m" withString:@""];
            } else if (_mFile.fileType == MixFileTypeMM) {
                _classFileName = [self.mFile.fileName stringByReplacingOccurrencesOfString:@".mm" withString:@""];
            }
        }
        
        if ([_classFileName containsString:@"AppDelegate"]) {
            _isAppDelegate = YES;
        }
        
    }
    return _classFileName;
}

@end
