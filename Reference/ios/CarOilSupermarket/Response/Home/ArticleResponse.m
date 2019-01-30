//
//  ArticleResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ArticleResponse.h"

@implementation ArticleItemInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"articleId":@"id"};
}

@end

@implementation ArticleInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"articles":@"ArticleItemInfo"};

}

@end

@implementation ArticleResponse

@end
