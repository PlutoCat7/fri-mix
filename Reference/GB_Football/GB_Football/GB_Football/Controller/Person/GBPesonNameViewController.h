//
//  GBPesonNameViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPesonNameViewController : GBBaseViewController

@property (nonatomic,copy) NSString* defaltName;
@property (nonatomic, assign) NSInteger minLenght;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic,copy) void(^saveBlock)(NSString* name);

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
