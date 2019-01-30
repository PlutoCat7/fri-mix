//
//  ScheduleDayCell.h
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleDayModel.h"
#import "ScheduleModel.h"

#define kLastUseArrayKey @"kLastUseArrayKey"
#define kScheduleIdKey @"kScheduleIdKey"
#define kScheduleIndexKey @"kScheduleIndexKey"

@interface ScheduleDayCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDay;

@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v2;
@property (weak, nonatomic) IBOutlet UIView *v3;
@property (weak, nonatomic) IBOutlet UIView *v4;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;

@property (nonatomic, strong) ScheduleDayListModel *dayListModel;

@property (nonatomic, strong) ScheduleDayModel * scheduleDay;
///记录号
@property (nonatomic, assign) long dayNum;

@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, assign) BOOL isNoCurrentMonthDay;

@property (nonatomic, assign) BOOL isWeekDay;

//记录已经使用的数据
@property (nonatomic, strong) NSMutableArray *arrArealyUse;
//记录上一个单元格使用的数据
@property (nonatomic, strong) NSMutableArray *arrLastUse;
@property (weak, nonatomic) IBOutlet UIImageView *imgVArrow;




@end
