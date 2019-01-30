//
//  TimerTweets.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TimerTweets.h"
#import "NSDate+Extend.h"
#import "modelDairy.h"
#import "Login.h"
@implementation TimerTweets

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = @0;
        _currentPageSize = @20;
        _monthpage = @-1;
        _ALLlist = [[NSArray alloc]initWithObjects:_currentMonthlist = [NSMutableArray new],_monthlist = [NSMutableArray new], nil];
        _currentMonthwillLoadMore = YES;
        _canLoadMore = YES;
    }
    return self;
}


- (NSString *)toPathWithCurrentMonth{
    return @"api/inter/logtimeaxis/pageStatus1ByHouseidnew";
}
- (NSDictionary *)toParamsWithCurrentMonth{
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:_currentPage forKey:@"start"];
    [dic setObject:_currentLastTime forKey:@"latesttime"];
    [dic setObject:_currentPageSize forKey:@"limit"];
//    [dic setObject:[NSDate ymFormat] forKey:@"month"];
    [dic setObject:@(_house.houseid) forKey:@"houseid"];
//    if (_isSearchResult) [dic setObject:@(_) forKey:]
    return [dic copy];
}

- (NSString *)toPath{
//    return @"api/inter/logtimeaxis/listLastThreeStatus1ByHouseidCountByMonth";
//    return @"api/inter/dairy/listThreeGroupByMonth";
    return @"/api/inter/dairy/listThreeGroupByMonth"; // 和云记录同一个接口
}
- (NSDictionary *)toParams{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[self ymFormat:[self datejishuangMonth:[_monthpage intValue]] ] forKey:@"month"];
    [dic setObject:@(_house.houseid) forKey:@"houseid"];
    return [dic copy];
}

-(NSDate *)datejishuangMonth:(int)month{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSCalendarIdentifierGregorian:iOS8之前用NSGregorianCalendar
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    //NSCalendarUnitYear:iOS8之前用NSYearCalendarUnit,NSCalendarUnitMonth,NSCalendarUnitDay同理
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    //    [adcomps setYear:year];
    [adcomps setMonth:month];
    //    [adcomps setDay:day];
    
    return [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
}


- (void)configWithCurrentMonth:(NSArray *)responseA{
    if (responseA && [responseA count] > 0) {
//        self.currentMonthCanLoadMore = YES;
        if (_currentMonthwillLoadMore) {
            [_currentMonthlist addObjectsFromArray:responseA];
        }else{
            [_currentMonthlist removeAllObjects];
            [_currentMonthlist addObjectsFromArray:responseA];
        }
    }else{
//        self.currentMonthCanLoadMore = NO;
        // 搜索结果为空时刷新
        if (!   _currentMonthwillLoadMore) {
            [_currentMonthlist removeAllObjects];
        }
    }
}


- (void)configWithMonthlist:(id)responseB{
    if (responseB) {
        self.canLoadMore = YES;
        if (_willLoadMore) {
//            [_monthlist addObject:responseB];
            [_monthlist addObjectsFromArray:responseB];
        }else{
            [_monthlist removeAllObjects];
//            [_monthlist addObject:responseB];
            [_monthlist addObjectsFromArray:responseB];
            
        }
    }else{
        self.canLoadMore = NO;
    }
}

- (NSString *)ymFormat:(NSDate *)date {
    
    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    [forma setDateFormat:@"yyyy-MM"];
    return [forma stringFromDate:date];;
}


-(NSIndexPath *)getNewTweetWithDairy:(Dairy *)dair{
    
    modelDairy *model = [[modelDairy alloc]init];
    model.dairy = dair;
    [_currentMonthlist addObject:model];
    
    NSSortDescriptor *des1 = [NSSortDescriptor sortDescriptorWithKey:@"dair.dairytime" ascending:YES];
    [_currentMonthlist sortUsingDescriptors:@[des1]];
    
    return [NSIndexPath indexPathForRow:[_currentMonthlist indexOfObject:model] inSection:0];
}

-(NSInteger)addTweet:(HouseTweet *)tweet{
    
    NSDate *nowDate = [NSDate date];
//    NSString *dateStr = [NSString stringWithFormat:@"%.0f", [nowDate timeIntervalSince1970]*1000];
//    long lastDateStr = [[dateStr substringFromIndex:dateStr.length-3] integerValue];
    
    TimerShaft *shaft = [[TimerShaft alloc]init];
//    shaft.latesttime = tweet.createData.length > 0 ? [[NSDate currentTimeString:tweet.createData] longLongValue] *1000 + lastDateStr : [NSDate timestampFromDate:[NSDate date]]*1000 + lastDateStr;
    if (tweet.diytime.length != 0) {
        shaft.latesttime = [tweet.diytime longLongValue];
    } else {
        shaft.latesttime =  tweet.createData.length > 0 ? [tweet.createData integerValue] : [nowDate timeIntervalSince1970]*1000;
    }
//    shaft.latesttime = tweet.createData.length > 0 ? tweet.createData : [NSDate timestampFromDate:[NSDate date]]*1000 + lastDateStr;

    modelDairy *daity = [[modelDairy alloc]init];
    Dairy *dairymodel = [[Dairy alloc]init];
    shaft.modelDairy = daity;
    shaft.modelDairy.dairy = dairymodel;
    shaft.modelDairy.dairy.dairytype = tweet.type==1 && tweet.images.count > 0 ? 1 : tweet.type;
    shaft.type = 1;
    shaft.modelDairy.dairy.arrurlfileArr = tweet.images;
    if (tweet.type == TweetTypeVideo) {
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:tweet.url];
        shaft.modelDairy.dairy.arrurlfileArr = arr;
        shaft.modelDairy.dairy.urlfilesmallArr = tweet.images;
    }
    shaft.modelDairy.dairy.dairydesc = tweet.dairydesc;
    shaft.modelDairy.dairy.dairytime = shaft.latesttime;
    shaft.modelDairy.dairy.dairycreatetime = (long)[nowDate timeIntervalSince1970]*1000;
    shaft.modelDairy.nickname = [Login curLoginUser].username;
    NSInteger idxn = 0;
    
    for (TimerShaft *obj in _currentMonthlist) {
        
            if (obj.latesttime < shaft.latesttime) {
                
                [_currentMonthlist insertObject:shaft atIndex:idxn];
                
                return idxn;
            }
        idxn ++;
    }
    
    [_currentMonthlist insertObject:shaft atIndex:idxn];
    
    return idxn;
}



@end

