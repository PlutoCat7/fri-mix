//
//  AccountBooksAddViewController.h
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

typedef void(^CompletionBlock)(long tallyid);

@interface AccountBooksAddViewController : BaseViewController

@property (assign, nonatomic) NSInteger Houseid;
@property (nonatomic, strong) House *house;
@property (copy, nonatomic) CompletionBlock completionBlock;

+ (instancetype)initWithStoryboard;


@end
