//
//  MixClassFile.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixFile.h"

@interface MixClassFile : NSObject <NSCoding>

@property (nonatomic , strong) MixFile * hFile;

@property (nonatomic , strong) MixFile * mFile;

@property (nonatomic , copy) NSString * classFileName;

@property (nonatomic , copy) NSString * resetFileName;

@property (nonatomic , assign , readonly) BOOL isAppDelegate;

@end

