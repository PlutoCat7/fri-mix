//
//  ArticleResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface ArticleItemInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end

@interface ArticleInfo : YAHDataResponseInfo

@property (nonatomic, strong) NSArray<ArticleItemInfo *> *articles;

@end

@interface ArticleResponse : COSResponseInfo

@property (nonatomic, strong) ArticleInfo *data;

@end
