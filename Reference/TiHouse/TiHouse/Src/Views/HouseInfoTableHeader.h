//
//  HouseInfoTableHeader.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/19.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseInfoTableHeader;
@protocol HouseInfoTableHeaderDelegate <NSObject>

-(void)HouseInfoTableMuneSelected:(HouseInfoTableHeader *)header Index:(NSInteger )index;

@end

@interface HouseInfoTableHeader : UIView

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *icon;//头像
@property (nonatomic, retain) UILabel *name;//房屋昵称
@property (nonatomic, retain) UILabel *estate;//小区
@property (nonatomic, retain) UIButton *editBtn;
@property (nonatomic, retain) NSMutableArray *BtnFramArr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, retain) House *house;
@property (weak, nonatomic) id<HouseInfoTableHeaderDelegate> delegate;
@property (nonatomic, copy) void(^editBlock)(void);
@property (nonatomic, copy) void(^iconBlock)(void);
-(NSMutableArray *)getMuneBnts;

@end

