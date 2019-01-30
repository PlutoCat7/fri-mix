//
//  RemindPeopleView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@interface RemindPeopleView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouse:(House *)house;

/**
 * 所需亲人数组
 */
@property (strong, nonatomic) NSMutableArray * selectPeopleArray;

/**
 * 编辑状态，所选人的uid
 */
@property (strong, nonatomic) NSString * schedulearruidtip;

@end
