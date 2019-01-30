//
//  RelationViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "House.h"
#import "Houseperson.h"

@interface RelationViewController : BaseViewController

@property (nonatomic, assign) NSInteger selectedBtn;
@property (nonatomic, copy) void(^finishBolck)(NSString *ValueStr, NSInteger item);
@property (nonatomic, strong) House *house;
@property (nonatomic, assign) NSArray<Houseperson *> *masters;

@end
