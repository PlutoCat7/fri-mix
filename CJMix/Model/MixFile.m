//
//  MixFile.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixFile.h"
#import "../Strategy/MixFileStrategy.h"
#import "MixEncryption.h"
#import "../Strategy/MixStringStrategy.h"

@implementation MixFile

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _path = [aDecoder decodeObjectForKey:@"path"];
        _fileName = [aDecoder decodeObjectForKey:@"fileName"];
        _data = [aDecoder decodeObjectForKey:@"data"];
        _subFiles = [aDecoder decodeObjectForKey:@"subFiles"];
        _fileType = [aDecoder decodeIntegerForKey:@"fileType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_path forKey:@"path"];
    [aCoder encodeObject:_fileName forKey:@"fileName"];
    [aCoder encodeObject:_data forKey:@"data"];
    [aCoder encodeObject:_subFiles forKey:@"subFiles"];
    [aCoder encodeInteger:_fileType forKey:@"fileType"];
    
}

- (void)setPath:(NSString *)path {
    _path = path;
    
    if (!_path) {
        return;
    }
    [self data];
    
}

- (void)save {
    if (self.isEdit) {
        MixEncryption * encryption = [MixEncryption encryptionWithFile:self];
        if (!encryption) {
            return;
        }
        self.data = [MixStringStrategy decoding:encryption.encryptionData originals:encryption.originals replaces:encryption.replaces];
        [MixFileStrategy writeFileAtPath:self.path content:self.data];
        self.isEdit = NO;
    }
}

- (NSString *)data {
    if (!_data) {
        NSData *data = [NSData dataWithContentsOfFile:self.path options:NSDataReadingMappedIfSafe error:nil];
        NSString * text  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _data = text;
    }
    return _data;
}

@end
