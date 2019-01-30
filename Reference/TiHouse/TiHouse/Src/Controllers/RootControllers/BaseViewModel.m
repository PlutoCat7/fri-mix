//
//  BaseViewModel.m
//  XinJiangTaxiProject
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 HeXiulian. All rights reserved.
//1.0.5新增

#import "BaseViewModel.h"
#import "BaseCellLineViewModel.h"

@implementation BaseViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.cellLineViewModel = [[BaseCellLineViewModel alloc] init];
        self.currentCellHeight = 0;
        _cellIndentifier = @"";
        self.cellBackgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellClass:(id)cellClass
{
    if (cellClass)
    {
        _cellClass = cellClass;
        _cellIndentifier = NSStringFromClass([cellClass class]);
    }
}


-(RACSubject *)failSubject{
    if (!_failSubject) {
        _failSubject = [RACSubject subject];
    }
    return _failSubject;
}

-(RACSubject *)successSubject{
    if (!_successSubject) {
        _successSubject = [RACSubject subject];
    }
    return _successSubject;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    BaseViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel) {
        [viewModel xl_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)xl_initialize{
    
}


@end
