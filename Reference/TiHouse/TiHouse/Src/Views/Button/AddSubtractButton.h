//
//  AddSubtractButton.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSubtractButton : UIView

@property (nonatomic, copy) void(^AddSubtractBlock)(NSMutableArray *, UIButton *btn);
@property (nonatomic, retain) NSMutableArray *Values;

-(instancetype)initWithFrame:(CGRect)frame Itemtitles:(NSArray *)titles;

@end
