//
//  NewBudgetPopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NewBudgetStyle) {
    NewBudgetStyleComfort = 1000,
    NewBudgetStyleQuality = 1001,
    NewBudgetStyleExtravagant = 1002,
    NewBudgetStyleEconomic = 1003
};

typedef NS_ENUM(NSInteger,NewBudgetPopTyoe) {
    NewBudgetPopTyoeOneKye = 0,
    NewBudgetPopTyoeWhatOneKye,
    NewBudgetPopTyoeAssess
};

@protocol NewBudgetPopViewDelegate<NSObject>

-(void)NewBudgetWithStyle:(NewBudgetStyle)Style;

@end


@interface NewBudgetPopView : UIView

@property (nonatomic ,assign) NewBudgetPopTyoe type;
@property (nonatomic ,weak) id<NewBudgetPopViewDelegate> delegate;

-(instancetype)initWithType:(NewBudgetPopTyoe)type;
-(void)Show;

@end
