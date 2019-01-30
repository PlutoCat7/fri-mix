//
//  RelativeFriViewController.h
//  TiHouse
//
//  Created by guansong on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "Houseperson.h"

typedef void(^RelativeChangeBlock)(id rst);

@interface RelativeFriViewController : BaseViewController

@property (nonatomic,strong) Houseperson *person;

@property (nonatomic,copy) RelativeChangeBlock block;


@end
