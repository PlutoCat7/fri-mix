//
//  GBPositionSelectView.h
//  GB_Team
//
//  Created by Pizza on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBPositionSelectView : UIView
// 返回选项
@property (nonatomic,copy) void(^saveBlock)(NSArray<NSString *>* selectIndexList);
// 打开右侧弹出框
+(GBPositionSelectView *)showWithSelectList:(NSArray<NSString *> *)selectList;
// 收起右侧弹出框
+(void)hide;

@end
