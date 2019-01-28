//
//  MixMethod.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixMethod : NSObject <NSCoding>

@property (nonatomic , copy) NSMutableArray <NSString *>* classMethods;

@property (nonatomic , copy) NSMutableArray <NSString *>* exampleMethods;

@property (nonatomic , copy) NSMutableArray <NSString *>* propertyMethods;

@end

