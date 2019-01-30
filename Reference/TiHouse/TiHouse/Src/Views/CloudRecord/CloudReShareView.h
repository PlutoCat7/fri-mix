//
//  CloudReShareView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "CloudReCollectItemModel.h"

@interface CloudReShareView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel;
@property (assign, nonatomic) long fileid;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * videoUrl;
@property (strong, nonatomic) CloudReCollectItemModel * itemModel;
@property (weak, nonatomic) UIViewController * viewVC;

@property (copy, nonatomic) void(^ShareBlock)(void);
@property (copy, nonatomic) void(^ToolBlock)(void);
@property (copy, nonatomic) void(^DelBlock)(void);

/**
 * 视图出现设置
 */
-(void)showSelectColorView;
-(void)dismissSelectColorView;

@end
