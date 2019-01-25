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
#import "../Strategy/MixClassStrategy.h"

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
        
        _hClasses = [NSArray arrayWithArray:[MixClassStrategy dataToClassName:hText]];
    }
    
    if (self.classFile.mFile) {
        
        NSData * mData = [NSData dataWithContentsOfFile:self.classFile.mFile.path options:NSDataReadingUncached error:nil];
        NSString * mText = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
        self.classFile.mFile.data = mText;
        _mClasses = [NSArray arrayWithArray:[MixClassStrategy dataToClassName:mText]];
    }
    
}






@end
