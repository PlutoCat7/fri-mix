//
//  MixConfig.h
//  CJMix
//
//  Created by ChenJie on 2019/1/25.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixConfig : NSObject

+ (instancetype)sharedSingleton;

@property (nonatomic , copy) NSString * mixPrefix;

@end

