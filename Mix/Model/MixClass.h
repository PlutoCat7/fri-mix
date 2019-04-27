//
//  MixClass.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixMethod.h"

@interface MixClass : NSObject <NSCoding>

@property (nonatomic , copy) NSString * className;

@property (nonatomic , copy) NSMutableArray <MixMethod *> *methods;

- (instancetype)initWithClassName:(NSString *)className;

@end

