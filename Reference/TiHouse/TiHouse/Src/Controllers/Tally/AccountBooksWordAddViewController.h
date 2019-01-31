//
//  AccountBooksWordAddViewController.h
//  TiHouse
//
//  Created by gaodong on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(id data);

@interface AccountBooksWordAddViewController : UIViewController

@property (copy, nonatomic) CompletionBlock completionBlock;

+ (instancetype)initWithStoryboard;

@end