//
//  CloudRecordHeadView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@interface CloudRecordHeadView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel;

@property (copy, nonatomic) void (^CloudReHeadImgClickBlock)(int index);
@property (copy, nonatomic) void (^CloudReSearchBarClickBlock)(void);

@property (nonatomic, copy) void (^clickBlock)(void);

/**
 * 设置头部信息
 */
-(void)setCloudRecordHeadViewInfo:(NSArray *)dataArray;

@end
