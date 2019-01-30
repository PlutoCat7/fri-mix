//
//  AddTallySingleInputViewController.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    Input_Model, // 型号
    Input_Brand, // 品牌
} AddTallySingleInputType;

typedef void(^SaveCompletionBlock)(NSString *textString);

@interface AddTallySingleInputViewController : BaseViewController

@property (copy, nonatomic) SaveCompletionBlock saveCompletionBlock;

@property (assign, nonatomic) AddTallySingleInputType inputType;

@property (strong, nonatomic) NSString *text;

@end
