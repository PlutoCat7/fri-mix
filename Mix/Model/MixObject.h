//
//  MixObject.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixObject.h"
#import "MixClassFile.h"
#import "MixClass.h"

#warning  it will be repealed
@interface MixObject : NSObject <NSCoding>

@property (nonatomic , strong , readonly) MixClassFile* classFile;

@property (nonatomic , strong , readonly) NSArray <MixClass *> *hClasses;

@property (nonatomic , strong , readonly) NSArray <MixClass *> *mClasses;

- (instancetype)initWithClassFile:(MixClassFile *)file;

@end
