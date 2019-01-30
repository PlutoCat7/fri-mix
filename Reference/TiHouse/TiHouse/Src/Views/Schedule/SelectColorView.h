//
//  SelectColorView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@interface SelectColorView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel;

/**
 * 选择颜色回调block
 */
@property (copy, nonatomic) void (^SelectColorBlock)(NSString * colorValue);
@property (copy, nonatomic) void (^DismissColorBlock)(void);

/**
 * 视图出现设置
 */
-(void)showSelectColorView;

@end
