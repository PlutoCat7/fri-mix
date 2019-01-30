//
//  NewBudgetPopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddBudgetNamePopView : UIView

@property (nonatomic ,copy) void(^finishBlock)(NSString *name);

-(instancetype)init;
-(void)Show;

@end
