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
    
    [self setupClassWithFile:self.classFile.hFile classes:_hClasses];
    [self setupClassWithFile:self.classFile.mFile classes:_mClasses];
    
}

- (void)setupClassWithFile:(MixFile *)file classes:(NSArray <MixClass *> *)classes {
    
    if (!file ||!self.classFile) {
        return;
    }
    
    NSData * hData = [NSData dataWithContentsOfFile:file.path options:NSDataReadingUncached error:nil];
    NSString * hText  = [[NSString alloc] initWithData:hData encoding:NSUTF8StringEncoding];
    file.data = hText;
    
    classes = [NSArray arrayWithArray:[MixClassStrategy dataToClassName:hText]];
    if (!self.classFile.resetFileName && classes.count) {
        MixClass * class = _hClasses[0];
        self.classFile.resetFileName = class.className;
    }
    
    
}






@end
