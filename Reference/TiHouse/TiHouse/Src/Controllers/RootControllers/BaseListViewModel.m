//
//  BaseListViewModel.m
//  XinJiangTaxiProject
//
//  Created by he on 2017/7/8.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//1.0.5新增

#import "BaseListViewModel.h"
#import "AppDelegate.h"
#import "UIView+Common.h"

@implementation BaseListViewModel

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)refreshUI {
    if (!_refreshUI) {
        _refreshUI = [RACSubject subject];
    }
    return _refreshUI;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (NSInteger)currentPage{
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSInteger)totalCount{
    if (!_totalCount) {
        _totalCount = 0;
    }
    return _totalCount;
}

- (id)getParamsWithPage:(int)page{
    return @{@"limit":@(kPageSize),@"start":@(page)};
}

- (void)xl_initialize{
    @weakify(self);
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //下拉刷新网络请求数据回来开关调用处理后
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id result) {
        //这里拿到下载回来的数据
        @strongify(self);
        //网络请求数据result
        self.result = result;
        
        @try {
            self.totalCount = [result[@"allCount"] integerValue];
        } @catch (NSException *exception) {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ((self.currentPage+1) * kPageSize >= self.totalCount) {
                //结束刷新
                [self.refreshEndSubject sendNext:@(XLHeaderRefresh_HasNoMoreData)];
            } else {
                //结束刷新
                [self.refreshEndSubject sendNext:@(XLHeaderRefresh_HasMoreData)];
            }
        });
    }];
    
    //下拉刷新正在加载提示
    [self.refreshDataCommand.executing subscribeNext:^(id x) {
        
        if ([x isEqualToNumber:@(YES)]  && !_isNoNeedLoading) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window beginLoading];
        }
    }];
    
    [self.nextPageCommand.errors subscribeNext:^(NSError * _Nullable x) {

        //结束刷新
        [self.refreshEndSubject sendNext:@(XLFooterRefresh_HasNoMoreData)];
    }];
    
    //上提刷新加载更多，网络请求回来数据开关处理后调用
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id result) {
        
        @strongify(self);
        @try {
            self.totalCount = [result[@"allCount"] integerValue];
        } @catch (NSException *exception) {
            
        }
        self.result = result;
        if ((self.currentPage+1) * kPageSize >= self.totalCount) {
            //判断是不是已经最后一页，是没有更多
            [self.refreshEndSubject sendNext:@(XLFooterRefresh_HasNoMoreData)];
            
        } else {
            //不是最后一页还有更多
            [self.refreshEndSubject sendNext:@(XLFooterRefresh_HasMoreData)];
        }
    }];
}

/**
 下载数据的主题
 
 @return =
 */
- (RACCommand *)refreshDataCommand {
    
    if (!_refreshDataCommand) {
        //开始时加载数据
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
//                //这里应该写网络请求
                
                [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:self.urlString withParams:self.params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                    
                     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.window endLoading];
                    if ([data[@"is"] intValue]) {
                        [subscriber sendNext:data];//开始下载数据的结果发送返回->刷新结束
                        [subscriber sendCompleted];//发送完成
                    }else{
                        
                        [self.refreshEndSubject sendNext:@(XLHeaderRefresh_HasNoMoreData)];
                    }
                    
                }];
              
                return nil;
            }];
        }];
        _refreshDataCommand.allowsConcurrentExecution = YES;//总是拿最新信号
    }
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    
    if (!_nextPageCommand) {
        
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                self.currentPage ++;//下一页
                //上提刷新，这里应该写网络请求
                //这里应该写网络请求
                
                [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:self.urlString withParams:self.params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.window endLoading];
                    if ([data[@"is"] intValue]) {
                        [subscriber sendNext:data];//开始下载数据的结果发送返回->刷新结束
                        [subscriber sendCompleted];//发送完成
                    }else{
                        self.currentPage --;
                        [self.refreshEndSubject sendNext:@(XLHeaderRefresh_HasNoMoreData)];
                    }
                    
                }];
                return nil;
            }];
        }];
        _nextPageCommand.allowsConcurrentExecution = YES;//总是拿最新信号，不写，信号不会被再次触发
    }
    
    return _nextPageCommand;
}

@end
