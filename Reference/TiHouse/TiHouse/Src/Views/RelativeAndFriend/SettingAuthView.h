//
//  SettingAuthView.h
//  TiHouse
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"
#import "Houseperson.h"

@interface SettingAuthView : BaseView

@property (nonatomic, strong) Houseperson *person;

@property (nonatomic, strong) NSMutableArray *arr;

///是不是主人
@property (nonatomic, assign) BOOL isMaster;

@property (weak, nonatomic) IBOutlet UILabel *lblTip;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIImageView *imgVVisitor;

@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btnBudget;

@property (weak, nonatomic) IBOutlet UIButton *btnAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnSchedule;

@end
