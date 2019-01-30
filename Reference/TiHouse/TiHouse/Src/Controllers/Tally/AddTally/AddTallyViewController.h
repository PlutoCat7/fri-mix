//
//  MoneyRecordAddViewController.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"


typedef enum : NSUInteger {
    AddTallyShowType_Input_Text, // 手动输入
    AddTallyShowType_Input_Voice, // 语音输入
    AddTallyShowType_Input_Word, // 智能输入
    AddTallyShowType_Show_Info, // 显示信息
} AddTallyShowType;

typedef void(^AddTallyViewControllerDismissBlock)(void);

@interface AddTallyViewController : BaseViewController

// 当前所属账本id
@property (assign) NSInteger houseId;
// 当前所属账本id
@property (assign) NSInteger tallyId;

@property (strong, nonatomic) House *house;
// 当前的类型
@property (assign) AddTallyShowType addTallyShowType;

@property (strong, nonatomic) TallyDetail *tallyDetail;

@property (copy, nonatomic) AddTallyViewControllerDismissBlock completionBlock;

// 参数是必填
+ (instancetype)initWithTallyId:(NSInteger)tallyId HouseId:(NSInteger)houseId House:(House*)house type:(AddTallyShowType)addTallyShowType;

@end
