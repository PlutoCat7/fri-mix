//
//  MixFile.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixFile.h"

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
    
    NSData * data = [NSData dataWithContentsOfFile:self.path options:NSDataReadingUncached error:nil];
    NSString * text  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.data = text;
    
}

@end
