//
//  Paginator.h
//  TiHouse
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paginator : NSObject
@property (nonatomic, assign) BOOL willLoadMore, canLoadMore;
@property (nonatomic, assign) NSInteger page, perPage;
@end
