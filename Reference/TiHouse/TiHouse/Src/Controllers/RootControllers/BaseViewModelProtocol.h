//
//  BaseViewModelProtocol.h
//  XinJiangTaxiProject
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//1.0.5新增

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XLHeaderRefresh_HasMoreData = 1,///下拉刷新有更多数据
    XLHeaderRefresh_HasNoMoreData,///下拉刷新无更多数据
    XLFooterRefresh_HasMoreData,///上提刷新有更多数据
    XLFooterRefresh_HasNoMoreData,///上提刷新无更多数据
    XLRefreshError,///刷新出错
    XLRefreshUI,///刷新UI
} XLRefreshDataStatus;

@protocol BaseViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;


/**
 *  初始化
 */
- (void)xl_initialize;


@end
