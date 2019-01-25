//
//  MixObject.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixObject.h"
#import "MixStringStrategy.h"
#import "../Strategy/MixJudgeStrategy.h"
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
    
    [self setupClassWithFile:self.classFile.hFile isHeader:YES];
    [self setupClassWithFile:self.classFile.mFile isHeader:NO];
    
}

- (void)setupClassWithFile:(MixFile *)file isHeader:(BOOL)isHeader {
    
    if (!file ||!self.classFile) {
        return;
    }
    
    NSData * hData = [NSData dataWithContentsOfFile:file.path options:NSDataReadingUncached error:nil];
    NSString * hText  = [[NSString alloc] initWithData:hData encoding:NSUTF8StringEncoding];
    file.data = hText;
    
    NSArray * classes = nil;
    if (isHeader) {
        _hClasses = [NSArray arrayWithArray:[MixClassStrategy dataToClassName:hText]];
        classes = _hClasses;
    } else {
        _mClasses = [NSArray arrayWithArray:[MixClassStrategy dataToClassName:hText]];
        classes = _mClasses;
    }
    
}






@end
