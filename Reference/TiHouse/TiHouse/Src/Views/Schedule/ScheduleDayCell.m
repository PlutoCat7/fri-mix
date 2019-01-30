//
//  ScheduleDayCell.m
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayCell.h"
#import "UIColor+expanded.h"
#import "NSDate+Extend.h"

#define kTodayTextColor RGB(255,255,255)
#define kTodayBGColor RGB(254, 192, 12)
#define kNoTodayBGColor RGB(255,255,255)
#define kNoTodayTextColor RGB(0,0,0)
#define kNoCurrentMonthTextColor RGB(191,191,191)
#define kWeekDayTextColor RGB(241, 56, 56)



@implementation ScheduleDayCell

- (NSMutableArray *)arrLastUse{
    if (!_arrLastUse) {
        _arrLastUse = [NSMutableArray new];
    }
    return _arrLastUse;
}
- (NSMutableArray *)arrArealyUse{
    if (!_arrArealyUse) {
        _arrArealyUse = [NSMutableArray new];
    }
    return _arrArealyUse;
}
- (void)setDayNum:(long)dayNum{
    _dayNum = dayNum;
    self.lblDay.text = JLong2String(dayNum);
    self.v1.hidden = YES;
    self.v2.hidden = YES;
    self.v3.hidden = YES;
    self.v4.hidden = YES;
    self.imgVArrow.hidden = YES;
    if (!_dayListModel) {
        self.isToday = NO;
        self.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = YES;
    }
}


- (void)setDayListModel:(ScheduleDayListModel *)dayListModel{
    _dayListModel = dayListModel;
    if (!dayListModel) {

        return;
    }
    self.dayNum = dayListModel.day;
    
    if (dayListModel.scheduleList.count>4) {
        self.imgVArrow.hidden = NO;
    }
    
    NSDate *date = [NSDate dateWithString:JString(@"%@-%ld",self.scheduleDay.date,dayListModel.day) format:@"yyyy-MM-dd"];
    
    self.isToday = [date isToday] ;
    
    [self.arrArealyUse removeAllObjects];

    [self setArrLastUseValus];
    
    NSUInteger row = dayListModel.scheduleList.count > 4 ? 4 : dayListModel.scheduleList.count;
    
    //遍历所有被使用的位置
    for (int i = 0 ; i< row; i++) {
        if (!dayListModel.scheduleList[i]) {
            continue;
        }
        NSInteger index = [self getLastIndex:dayListModel.scheduleList[i]];
        
        if (index != -1) {
             NSDictionary *dic = [self getDataWithScheduleDay:dayListModel.scheduleList[i]];
             [self setDetailWithIndex:index scheduleDay:dayListModel.scheduleList[i] hasNext:[dic[@"hasNext"] boolValue]];
        }
    }

    for (int i = 0 ; i < row; i++) {
        if (!dayListModel.scheduleList[i]) {
            continue;
        }
        if ([self contentWithSchedule:dayListModel.scheduleList[i]]) {
            continue;
        }
        
        
        NSInteger index = [self getLastIndex:dayListModel.scheduleList[i]];
        if (index != -1) {
            continue;
        } else {
            index = [self getNoUseIndex];
            [self.arrArealyUse addObject:@{kScheduleIdKey:@(dayListModel.scheduleList[i].scheduleid),
                                           kScheduleIndexKey:@(index)
                                           }];
        }
        NSDictionary *dic = [self getDataWithScheduleDay:dayListModel.scheduleList[i]];
        
        [self setDetailWithIndex:index scheduleDay:dayListModel.scheduleList[i] hasNext:[dic[@"hasNext"] boolValue]];
    }
    //重新更新最后一次使用的位置
    self.arrLastUse = self.arrArealyUse;
    //保存
    [self saveLastUseArray];
    
}

/**
 已经存在

 @param scheduleModel <#scheduleModel description#>
 @return <#return value description#>
 */
- (BOOL)contentWithSchedule:(ScheduleModel *)scheduleModel{
    
    for (NSDictionary *dic  in self.arrArealyUse) {
        if ([dic[kScheduleIdKey] integerValue] == scheduleModel.scheduleid) {
            return YES;
        }
    }
    return NO;
}



- (NSInteger)getNoUseIndex{
    

    for (int i = 0; i< 4; i++) {
        BOOL hasContent = NO;
        for ( int j = 0; j< self.arrArealyUse.count ; j++) {
            
            NSDictionary *dic = self.arrArealyUse[j];
            if ( i == [dic[kScheduleIndexKey] integerValue]) {
                hasContent = YES;
                break;
            }
        }
        if (!hasContent) {
            return i;
        }
    }
    return -1;
}



/**
 获取前一天的位置使用情况
 */
- (void)setArrLastUseValus{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    self.arrLastUse = [def objectForKey:kLastUseArrayKey];
    if (!self.arrLastUse) {
        self.arrLastUse = [NSMutableArray new];
    }
}

/**
 存储今天位置使用情况
 */
- (void)saveLastUseArray{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //存入数组并同步
    [def setObject:self.arrLastUse forKey:kLastUseArrayKey];
    [def synchronize];

}


/**
 获取上次的位置
 @param scheduleModel 事件对象
 @return 位置 -1：没有
 */
- (NSInteger)getLastIndex:(ScheduleModel *)scheduleModel{
    
    for (NSDictionary *dic in self.arrLastUse) {
        
        if ([dic[kScheduleIdKey] integerValue] == scheduleModel.scheduleid) {
            
            //记录已经被使用的
            [self.arrArealyUse addObject:dic];
            
            return [dic[kScheduleIndexKey] integerValue];
        }
    }
    return -1;
}

- (void)setDetailWithIndex:(NSInteger)index scheduleDay:(ScheduleModel *)scheduleModel hasNext:(BOOL)hasNext{
    
    UILabel *lbl;
    UIView *v;
    UIImageView *imgV;
    
    switch (index) {
        case 0:{
            lbl = self.lbl1;
            v = self.v1;
            imgV = self.img1;
            self.v1.hidden = NO;
        }
            break;
        case 1:{
            lbl = self.lbl2;
            v = self.v2;
            imgV = self.img2;
            self.v2.hidden = NO;
        }
            break;
        case 2:{
            lbl = self.lbl3;
            v = self.v3;
            imgV = self.img3;
            self.v3.hidden = NO;
        }
            break;
        case 3:{
            lbl = self.lbl4;
            v = self.v4;
            imgV = self.img4;
            self.v4.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    if (!v.hidden) {
        
        long dateS = scheduleModel.schedulestarttime/1000;
        NSString *date = [NSDate timeStringFromTimestamp:dateS formatter:@"yyyy-MM-dd"];
        
        NSInteger count = [NSDate calSpaceDayDate:date endDate:JString(@"%@-%ld",self.scheduleDay.date,self.dayNum)];
        NSString *strTip = [NSString emojizedStringWithString:scheduleModel.schedulename];
        
        int chCount = kScreen_Width >320 ? (kScreen_Width > 375 ? 5 : 4):3;
        
        
        if (strTip.length > chCount * (count +1)) {
             strTip = [strTip substringToIndex:chCount * (count +1)];
             strTip = [strTip substringFromIndex:chCount * count];
        }else if (strTip.length > chCount * (count)){
            strTip = [strTip substringFromIndex:chCount * (count)];
        }else{
            strTip = @"";
        }
        
//
//        switch (count) {
//            case 0:{
//                if (strTip.length >chCount) {
//                    strTip = [strTip substringToIndex:chCount];
//                }
//            }
//                break;
//            case 1:{
//                if (strTip.length >chCount*2) {
//                    strTip = [strTip substringFromIndex:chCount];
//                    strTip = [strTip substringToIndex:chCount];
//
//                } else if (strTip.length >chCount){
//                    strTip = [strTip substringFromIndex:chCount];
//                }else {
//                     strTip = @"";
//                }
//            }
//                break;
//            case 2:{
//                if (strTip.length >chCount*3) {
//                    strTip = [strTip substringFromIndex:chCount*2];
//                    strTip = [strTip substringToIndex:chCount];
//
//                } else if (strTip.length >chCount*2) {
//                    strTip = [strTip substringFromIndex:chCount*2];
//                } else {
//                    strTip = @"";
//                }
//            }
//                break;
//            case 3:{
//                if (strTip.length >chCount*4) {
//                    strTip = [strTip substringFromIndex:chCount*3];
//                    strTip = [strTip substringToIndex:chCount];
//                }else if (strTip.length >chCount*3) {
//                    strTip = [strTip substringFromIndex:chCount*2];
//                    strTip = [strTip substringToIndex:chCount];
//
//                }  else {
//                    strTip = @"";
//                }
//            }
//                break;
//            default:
//                strTip = @"";
//                break;
//        }
        
        lbl.text = IF_NULL_TO_STRINGSTR(strTip, @"");

        imgV.hidden = !scheduleModel.scheduletype;
        if (hasNext) {
            imgV.hidden = YES;
        }
        v.backgroundColor = [UIColor colorWithHexString:JString(@"0x%@",scheduleModel.schedulecolor)];
     
       
    }
}

- (void)setIsToday:(BOOL)isToday{
    _isToday = isToday;
    if (_isToday) {
        self.lblDay.textColor = kTodayTextColor;
        self.lblDay.backgroundColor = kTodayBGColor;
    } else {
        self.lblDay.backgroundColor = kNoTodayBGColor;
        if (self.isWeekDay) {
            self.lblDay.textColor = kWeekDayTextColor;
        }else if(self.isNoCurrentMonthDay){
           self.lblDay.textColor = kNoCurrentMonthTextColor;
        } else {
            self.lblDay.textColor = kNoTodayTextColor;
        }
    }
}

/**
 获取是否还有下一个

 @param scheduleModel <#scheduleModel description#>
 @return <#return value description#>
 */
- (id)getDataWithScheduleDay:(ScheduleModel *)scheduleModel{
    
    long dateS = scheduleModel.scheduleendtime/1000;
    NSString *date = [NSDate timeStringFromTimestamp:dateS formatter:@"yyyy-MM-dd"];
    
    NSInteger count = [NSDate calSpaceDayDate:JString(@"%@-%ld",self.scheduleDay.date,self.dayNum) endDate:date];
    

    BOOL hasNext = count > 0; //[self getHasNextWithScheduleDay:scheduleModel];
 
    return @{@"hasNext":@(hasNext)};
}

- (int)getIndexWithScheduleDay:(ScheduleModel *)scheduleModel{
    int index = -1;
    
    for (int i = 0; i< self.scheduleDay.list.count; i++) {
        
        ScheduleDayListModel *m = self.scheduleDay.list[i];
        
        for (int j = 0; j< m.scheduleList.count; j++) {
            ScheduleModel *model = m.scheduleList[j];
            if (scheduleModel.scheduleid == model.scheduleid) {
                index = j;
                return index;
            }
        }
    }
    return index;
}

//- (BOOL)getHasNextWithScheduleDay:(ScheduleModel *)scheduleModel{
//    BOOL hasNext = NO;
//
//    for (int x = (int)self.scheduleDay.list.count - 1; x >= 0; x--) {
//
//        ScheduleDayListModel *m = self.scheduleDay.list[x];
//        int day = m.day;
//
//        for (int y = 0; y< m.scheduleList.count; y++) {
//            ScheduleModel *model = m.scheduleList[y];
//            if (scheduleModel.scheduleid == model.scheduleid) {
//
//                if (day == self.dayNum) {
//                    hasNext = NO;
//                }else{
//                    hasNext = YES;
//                }
//                return hasNext;
//            }
//        }
//    }
//    return hasNext;
//}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

@end
