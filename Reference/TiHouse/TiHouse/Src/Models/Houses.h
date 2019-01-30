//
//  Houses.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
@interface Houses : NSObject

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (readwrite, nonatomic, strong) NSMutableArray *list;
@property (readwrite, nonatomic, strong) NSNumber *page, *pageSize;

- (NSString *)toPath;
- (NSDictionary *)toParams;
- (void)configWithHouess:(NSArray *)responseA;

@end
