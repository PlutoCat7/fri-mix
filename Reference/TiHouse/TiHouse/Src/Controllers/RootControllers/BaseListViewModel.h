//
//  BaseListViewModel.h
//  XinJiangTaxiProject
//
//  Created by he on 2017/7/8.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//1.0.5新增

#import "BaseViewModel.h"

#define kPageSize 10

@interface BaseListViewModel : BaseViewModel
///请求url
@property (nonatomic, copy) NSString *urlString;
///上传参数
@property (nonatomic, strong) id params;
///服务器请求的数据
@property (nonatomic, strong) id result;
///刷新结束
@property (nonatomic, strong) RACSubject *refreshEndSubject;
///刷新UI
@property (nonatomic, strong) RACSubject *refreshUI;
///刷新数据
@property (nonatomic, strong) RACCommand *refreshDataCommand;
///下载下一页
@property (nonatomic, strong) RACCommand *nextPageCommand;
///单元格点击
@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, assign) NSInteger totalCount, currentPage;

/**
是否需要loading
 */
@property (nonatomic, assign) BOOL isNoNeedLoading;


@end
