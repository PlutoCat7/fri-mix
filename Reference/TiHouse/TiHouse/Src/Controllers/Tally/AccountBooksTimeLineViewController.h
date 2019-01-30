//
//  AccountBooksTimeLineViewController.h
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@interface AccountBooksTimeLineViewController : BaseViewController

@property (nonatomic) long Tallyid;

+ (instancetype)initWithStoryboard;

@property (nonatomic, strong) House *house;


@end
