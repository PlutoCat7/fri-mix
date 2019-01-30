//
//  KnowledgeUtil.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KnowledgeUtil.h"

@implementation KnowledgeUtil

+ (NSString *)nameWithKnowType:(KnowType)knowType {
    NSString *name = @"";
    
    switch (knowType) {
        case KnowType_Poster:
            name = @"有数小报";
            break;
            
        case KnowType_SFurniture:
            name = @"家具";
            break;
            
        case KnowType_SIndoor:
            name = @"室内常用";
            break;
            
        case KnowType_SLiveroom:
        case KnowType_FLiveroom:
            name = @"客厅";
            break;
            
        case KnowType_SRestaurant:
        case KnowType_FRestaurant:
            name = @"餐厅";
            break;
            
        case KnowType_SRoom:
        case KnowType_FRoom:
            name = @"卧室";
            break;
            
        case KnowType_SKitchen:
        case KnowType_FKitchen:
            name = @"厨房";
            break;
            
        case KnowType_FToilet:
            name = @"卫生间";
            break;
            
        case KnowType_FOther:
            name = @"其它";
            break;
            
        default:
            break;
    }
    
    return name;
}

+ (NSString *) compareCurrentTime:(NSTimeInterval)timeInter
{
    
    //把字符串转为NSdate
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeInter];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = timeInter;
//    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else{
        //把字符串转为NSdate
        
        result = [NSString stringWithFormat:@"%d-%02d-%02d", (int)timeDate.year, (int)timeDate.month, (int)timeDate.day];
    }
    
    return  result;
}

@end
