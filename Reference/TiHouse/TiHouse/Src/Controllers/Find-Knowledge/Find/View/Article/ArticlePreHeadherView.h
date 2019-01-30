//
//  ArticlePreHeadherView.h
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kArticlePreHeadherViewHeight kRKBWIDTH(310)

@class FindDraftSaveModel;
@class FindAssemarcInfo;
@interface ArticlePreHeadherView : UIView

- (void)refreshWithDraftModel:(FindDraftSaveModel *)model;

- (void)refreshWithAssemarcInfo:(FindAssemarcInfo *)info;

+ (CGFloat)defaultHeight:(NSString *)content;

@end
