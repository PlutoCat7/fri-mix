//
//  BaseView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init{
    if (self = [super init]) {
        [self xl_setupViews];
        [self xl_bindViewModel];
    }
    return self;
}

#pragma mark protocol
- (instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    if (self = [super init]) {
        [self xl_setupViews];
        [self xl_bindViewModel];
    }
    return self;
}

+ (instancetype)sharedInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)xl_setupViews{
    
}

- (void)xl_bindViewModel{
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
