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
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
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
