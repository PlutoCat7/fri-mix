//
//  ArticleLikeView.h
//  TiHouse
//
//  Created by yahua on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//  文章点赞View

#import <UIKit/UIKit.h>

#define kArticleLikeViewHeight kRKBWIDTH(170)

@class FindAssemarcInfo;
@class ArticleLikeView;
@protocol ArticleLikeViewDelegate <NSObject>

- (void)articleLikeViewActionLike:(ArticleLikeView *)view;

@end

@interface ArticleLikeView : UIView

@property (nonatomic, weak) id<ArticleLikeViewDelegate> delegate;

- (void)refreshWithInfo:(FindAssemarcInfo *)info;

@end
