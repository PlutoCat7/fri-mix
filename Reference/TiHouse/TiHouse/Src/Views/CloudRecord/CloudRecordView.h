//
//  CloudRecordView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@interface CloudRecordView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouse:(House *)house;

@property (weak, nonatomic) UIViewController * viewController;
@property (nonatomic, strong) RACSubject * cellClickSubject;
@property (nonatomic, strong) RACSubject * headerClickSubject;
@property (nonatomic, strong) RACSubject * changeEditBtnSubject;
@property (nonatomic, strong) RACSubject * searchBarClickSubject;

/**
 * 点击编辑事件
 */
-(void)clickEditAction;

/**
 * 点击完成事件
 */
-(void)clickDoneAction;

-(void)refreshData;

@end
