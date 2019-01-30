//
//  modelDairy.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dairy.h"
#import "TweetComment.h"
@interface modelDairy : NSObject

//昵称
@property (nonatomic, copy) NSString *nickname;
//评论总条数
@property (nonatomic, copy) NSString *countdairycomm;
//点赞列表
@property (nonatomic, retain) NSMutableArray <Dairyzan *>* listModelDairyzan;
//评论列表
@property (nonatomic, retain) NSMutableArray <TweetComment *>* listModelDairycomm;
//内容详情
@property (nonatomic, strong) Dairy *dairy;

@property (nonatomic ,assign) CGFloat CellHight;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (readwrite, nonatomic, strong) NSNumber *page, *pageSize;

//评论分页
-(NSString *)toCommentPath;
- (void)configWithHouess:(NSArray *)responseA;

-(void)ClickZan:(Dairyzan *)zan;
-(void)CancelZan;


@end

