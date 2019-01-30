//
//  TiHouse_NetAPIManager.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiHouseNetAPIClient.h"

@class Login, AddresManager ,Houses ,House ,HouseTweet,Budgets,Budget,Budgetpro,BudgetThreeClass,Logbudgetopes,TimerTweets,Dairyzan,TweetComment,AddScheduleModel,modelDairy, TimerShaft;

@interface TiHouse_NetAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark -- UnReadNotifications
- (void)request_UnReadNotificationsWithBlock:(void (^)(id data, NSError *error))block;

- (void)request_WithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;
#pragma mark -- Advertising
- (void)request_AdvertisingandBlock:(void (^)(id data, NSError *error))block;

#pragma mark -- UserLogin
- (void)request_OpenIDOAuthUserInfoWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;
- (void)request_OpenIDOAuthLoginWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;
- (void)request_MesssgeCodeWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;
-(void)request_UserRegisterWithMyLogin:(Login *)login Block:(void (^)(id data, NSError *error))block;

#pragma mark -- Addres
-(void)request_AddresWith:(AddresManager *)addres Block:(void (^)(id data, NSError *error))block;

#pragma mark -- House
-(void)request_HousePageWithpageHouses:(Houses *)house Block:(void (^)(id data, NSError *error))block;
-(void)request_AddHouseWithHouse:(House *)houses Block:(void (^)(id data, NSError *error))block;
-(void)request_EditHouseWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block;
-(void)request_HouseInfoWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;
- (void)request_ResetCodeinviteWithHouseid:(NSInteger)houseid Block:(void (^)(id data, NSError *error))block;

#pragma mark -- Houseperson
- (void)request_HousepersonWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;

#pragma mark -- file
- (void)request_FilesBlockWith:(House *)house Block:(void (^)(id data, NSError *error))block;

#pragma mark -- finders
- (void)request_FindersWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block;

#pragma mark -- Housetweet
- (void)request_addHouseTweetWithTweet:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(id data, NSError *error))block;

// 发布 & 编辑
- (void)request_addHouseTweetWithQiNiu:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(Dairy *data, NSError *error))block;


- (void)request_addHouseTweetVidoWithTweet:(HouseTweet *)tweet isEdit:(BOOL)isEdit Block:(void (^)(id data, NSError *error))block;


#pragma mark -- Budget - 预算列表
-(void)request_BudgetListWithBudgets:(Budgets *)budgets Block:(void (^)(id data, NSError *error))block;
-(void)request_LookTransformListWithLogbudgetopes:(Logbudgetopes *)logbudgetopes Block:(void (^)(id data, NSError *error))block;
-(void)request_NewBudgetWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block;
-(void)request_RemoveBudgetWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block;
-(void)request_BudgetproWithBudgets:(Budget *)budget Block:(void (^)(id data, NSError *error))block;
-(void)request_LatestBudgetWithHouse:(House *)house Block:(void (^)(id data, NSError *error))block;
-(void)request_CopyBudgetWithBudgetpro:(Budgetpro *)budgetpro Block:(void (^)(id data, NSError *error))block;
-(void)request_BudgetProEditWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block;
-(void)request_BudgetProAddWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block;
-(void)request_BudgetProRemoveWithBudgetThreeClass:(BudgetThreeClass *)threeClass Block:(void (^)(id data, NSError *error))block;

#pragma mark -- Budget - 时间轴首页
-(void)request_TimerShaftWithTimerTweets:(TimerTweets *)timerTweets Block:(void (^)(id data, NSInteger allCount, NSError *error))block;
-(void)request_TimerShaftMonthWithTimerTweets:(TimerTweets *)timerTweets Block:(void (^)(id data, NSError *error))block;
-(void)request_TimerShaftZanWithDairyzan:(Dairyzan *)dairyzan isZan:(BOOL)isZan Block:(void (^)(id data, NSError *error))block;
-(void)request_TimerShaftTweetComment:(TweetComment *)tweetComment Block:(void (^)(id data, NSError *error))block;
-(void)request_TimerShaftTweetCommentList:(modelDairy *)modelDairy Params:(NSDictionary *)Params Block:(void (^)(id data, NSError *error))block;

#pragma mark -- schedule
- (void)request_scheduleColorSelectBlock:(void (^)(id data, NSError *error))block;
- (void)request_addScheduleSelect:(AddScheduleModel *)addScheduleModel withPath:(NSString *)path Block:(void (^)(id data, NSError *error))block;

#pragma mark -- cloudrecord
- (void)request_cloudRecordListCountWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordListByHouseidWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordListCountByMonthWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordCollectsWithPath:(NSString *)path withParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordAddFolderWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordDelFolderWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordDelFileWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;
- (void)request_cloudRecordCollectFileWithParams:(NSDictionary *)params Block:(void (^)(id data, NSError *error))block;

#pragma mark - relativeAndFriend
- (void)request_RelativeAndFriendHousepersonWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;

#pragma mark - Advertisements
- (void)request_AdvertisementsWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;

- (void)request_knowLedgeAdvertisementsWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;

#pragma mark - 发现
- (void)request_discoveryListWithPage:(NSInteger)page UsingBlock:(void(^)(id data, NSError *error))block;

#pragma mark - 美家征集
- (void)request_assemListUsingBlock:(void(^)(id data, NSError *error))block;

#pragma mark - 关注某用户
- (void)request_followSomeBodyWithUid:(NSString *)uid completedUsing:(void(^)(id data , NSError *error))block;

#pragma mark - 取消关注某用户
- (void)request_unFollowSomeBodyWithUid:(NSString *)uid completedUsing:(void(^)(id data , NSError *error))block;

#pragma mark - 我关注的发现
- (void)request_myConcernDiscoveryListWithPage:(NSInteger)page usingBlock:(void (^)(id, NSError *))block;

#pragma mark - 查询个人信息
- (void)request_checkSomeOnesProfileWithUid:(NSInteger)uid completedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 查询个人文章、图片
- (void)request_articleAndDiscoveryWithUid:(NSInteger)uid index:(NSInteger)index type:(NSInteger)type completedUsing:(void (^)(id data, NSError *error))block;

#pragma mark - 删除文章或者图片
- (void)request_deleteArticleAndPhotoWithCid:(NSInteger)cid completedUsing:(void(^)(id data,NSError *error))block;

#pragma mark - 上传图片 七牛云
- (void)request_uploadFilesWithData:(NSData *)data completedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 编辑发现个人封面图片
- (void)request_EditAssembgurlWithUrl:(NSString *)url completedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 未读消息数量
- (void)request_unreadMessageNumberCompletedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 我收藏的文章
- (void)request_collectedArticleWithIndex:(NSInteger)index completedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 广告统计
- (void)request_advertclickWithAdvId:(NSString *)advId type:(NSString *)advType completedUsing:(void(^)(id data,NSError *error))block;

#pragma mark - 查询个人数据
- (void)request_checkMyProfileCompletedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 查询手机号是否被注册
- (void)request_checkMobileHasBeenRegistedWithMobile:(NSString *)mobile completedUsing:(void(^)(id data, NSError *error))block;

#pragma mark - 我收藏的有数小报
- (void)request_myCollectedPostWithIndex:(NSInteger)index completedUsing:(void(^)(id data, NSError *error))block;

@end

