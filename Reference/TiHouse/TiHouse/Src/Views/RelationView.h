//
//  RelationView.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Houseperson.h"

@class House;


@interface RelationView : UIView

@property (nonatomic, assign) NSInteger selectedBtn;
@property (nonatomic, copy) void(^finishBolck)(NSString *ValueStr, NSInteger item);
@property (nonatomic, strong) House *house;
@property (nonatomic, strong) NSArray<Houseperson *> *masters;

@end
