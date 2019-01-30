//
//  Houses.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Houses.h"
#import "User.h"
#import "Login.h"

@implementation Houses


- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = @0;
        _pageSize = @10;
    }
    return self;
}



- (NSString *)toPath{
    NSString *requstPath = @"api/inter/house/pageByUid";
    return requstPath;
}


-(NSDictionary *)toParams{
    
    return  @{@"start":_page,@"limit":_pageSize};
}

- (void)configWithHouess:(NSArray *)responseA{
    if (responseA && [responseA count] > 0) {
        self.canLoadMore = YES;
        if (_willLoadMore) {
            [_list addObjectsFromArray:responseA];
        }else{
            self.list = [NSMutableArray arrayWithArray:responseA];
        }
    }else{
        self.canLoadMore = NO;
        if (!_willLoadMore) {
            self.list = [NSMutableArray array];
        }
    }
}


@end
