//
//  AccountBooksViewController.h
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "House.h"

@interface AccountBooksViewController : BaseViewController

@property (assign, nonatomic) NSInteger Houseid;
@property (assign, nonatomic) BOOL stopRedirect;
@property (nonatomic, strong) House *house;

+ (instancetype)initWithStoryboard;

@end
