//
//  EventPopAlertView.h
//  TiHouse
//
//  Created by guansong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePopAlertView.h"
@class EventPopAlertView;

enum ActionType{
    DoneAction,
    DeleteAction,
    EditAction,
};
typedef void(^EventPopViewAddBlock)(id param);

typedef void(^EventPopViewActionBlock)(EventPopAlertView *alertView, enum ActionType type,NSIndexPath * index,id obj);

@interface EventPopAlertView : BasePopAlertView
/**
 显示弹框
 @param arrData pick数据
 @param title 标题
 @param actionBlock 选择的数据回调
 @param addBlock 添加按钮的回调
 */
+ (void)showWithTitle:(NSString *) title
           andWeekday:(NSString *) weekday
                       Data:(NSArray *)arrData
             ActionCallBack:(EventPopViewActionBlock) actionBlock
                AddCallBack:(EventPopViewAddBlock)addBlock;

@end
