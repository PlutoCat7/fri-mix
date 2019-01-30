//
//  TallyCategory.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TallySecondCategoryModel, TallyThridCategoryModel;

@interface TallyCategory : NSObject

@property (assign, nonatomic) NSInteger cateoneid;
@property (strong, nonatomic) NSString *cateonename;
@property (assign, nonatomic) NSInteger cateonesort;
@property (strong, nonatomic) NSString *urlicon;
@property (strong, nonatomic) NSMutableArray<TallySecondCategoryModel *> *catetwoList; // 二级分类数组


@end

// 二级分类
@interface TallySecondCategoryModel: NSObject
@property (assign, nonatomic) NSInteger cateoneid;
@property (assign, nonatomic) NSInteger catetwoid;
@property (strong, nonatomic) NSString *catetwoname;
@property (assign, nonatomic) NSInteger catetwosort;
@property (assign, nonatomic) NSInteger catetwostatus; // 0不显示，1显示
@property (strong, nonatomic) NSMutableArray<TallyThridCategoryModel *> *tallytempletList; // 三级分类数组
@end

// 三级分类
@interface TallyThridCategoryModel: NSObject
@property (assign, nonatomic) NSInteger catethreeid;
@property (assign, nonatomic) NSInteger cateoneid;
@property (assign, nonatomic) NSInteger catetwoid;
@property (strong, nonatomic) NSString *catename;
@property (assign, nonatomic) NSInteger tallyid; // 所属账本id
@property (assign, nonatomic) NSInteger tallytempletid; // 记账模板id
@end
