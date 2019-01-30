//
//  RelationViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class House,Houseperson;
@interface PerfectRelationViewController : BaseViewController

@property (nonatomic, retain) House *house;
@property (nonatomic, retain) Houseperson *houseperson;
@property (nonatomic, copy) void(^finishBolck)(NSString *ValueStr, NSInteger item);

@end
