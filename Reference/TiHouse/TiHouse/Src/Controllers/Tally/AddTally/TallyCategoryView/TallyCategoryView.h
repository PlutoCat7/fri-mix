//
//  TallyCategoryView.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TallyCategoryViewDelegate<NSObject>

- (void)tallyCategoryAddProjectAction:(NSInteger)catetwoid;

- (void)refreshCellHeight:(CGFloat)height;

- (void)didSelected:(TallyCategory *)firstCategory secondCategory:(TallySecondCategoryModel *)secondCategory thridCategory:(TallyThridCategoryModel *)thridCategory;
@end

@interface TallyCategoryView : UIView

@property (nonatomic) NSInteger cateoneid;
@property (nonatomic) NSInteger catetwoid;
@property (nonatomic) NSInteger catethreeid;

@property (weak, nonatomic) id<TallyCategoryViewDelegate> delegate;

- (void)show:(NSArray<TallyCategory *> *)categoryList;

- (void)refreshViewHeight;

@end
