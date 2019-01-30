//
//  BaseViewModel.h
//  XinJiangTaxiProject
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//1.0.5新增

#import <Foundation/Foundation.h>
#import "BaseViewModelProtocol.h"

@class BaseCellLineViewModel;

@interface BaseViewModel : NSObject<BaseViewModelProtocol>

//成功回调
@property (nonatomic, strong) RACSubject *successSubject;
//失败回调
@property (nonatomic, strong) RACSubject *failSubject;



//the line in cell ViewModel,you can set up the line attributed,such as lineColor、lineHeight、position of line;
@property (nonatomic,strong  ) BaseCellLineViewModel *cellLineViewModel;

//the origin dataModel
@property (nonatomic,strong  ) id dataModel;

//the backgroundColor of tableviewCell.
@property (nonatomic,strong  ) UIColor *cellBackgroundColor;

//the className of tableviewCell.
@property (nonatomic,strong  ) id cellClass;

//the height of tableviewcellHeight,default is define cellDefaultHeight(44).
@property (nonatomic,assign  ) NSInteger currentCellHeight;

//cell indetifier
@property (nonatomic,readonly) NSString *cellIndentifier;

//cellType
@property (nonatomic,assign  ) NSInteger cellType;


@end
